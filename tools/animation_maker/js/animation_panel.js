/**@type {Set<ViewportAnimation>} */
const animations = new Set();

const animationPanel = document.querySelector("#animation_panel");

const animationInfo = document.querySelector("#animation_info");
const animationSelectElement = animationPanel.querySelector("#animation_selector");
const currentFrameElement = animationPanel.querySelector("#current_frame_input");
const endFrameElement = animationPanel.querySelector("#end_frame_input");
const fpsElement = animationPanel.querySelector("#fps_input");
const animationLoopCheckbox = animationPanel.querySelector("#animation_loop_checkbox");

const createAnimationButton = document.querySelector("#create_animation_button");
const renameAnimationButton = document.querySelector("#rename_animation_button");
const deleteAnimationButton = document.querySelector("#delete_animation_button");

const animationPlayButton = document.querySelector("#play_button");
const animationNextFrameButton = document.querySelector("#next_frame");
const animationPreviousFrameButton = document.querySelector("#previous_frame");

const timelineContainer = document.querySelector("#timeline_container");
const timelineOverlay = document.querySelector("#timeline_overlay");
const timelineKeyframes = document.querySelector("#timeline_keyframes");

const timelineElement = document.querySelector("#timeline");
const timelineCursor = document.querySelector("#timeline_cursor");

const timelineScrollerContainer = document.querySelector("#timeline_scroller_container");
const timelineScroller = document.querySelector("#timeline_scroller");

let nextAnimationId = -1;

animationInfo.addEventListener("wheel", e => {
    e.preventDefault();
    animationInfo.scrollLeft += e.deltaY / 6;
})

function removeAllChildren(element) {
    Array.from(element.children).forEach(child=>child.remove());
}

function addClassTo(elements, ...args) {
    elements.forEach(element => element.classList.add(args));
}

function removeClassTo(elements, className) {
    elements.forEach(element => element.classList.remove(className));
}

function clamp(value, min, max) {
    return Math.min(max, Math.max(value, min));
}

class Timeline {
    _maxFrames = 30;
    _scrollOffset = 0;

    /**@type {?ViewportAnimation} */
    _animation = null;

    selectedKeyframes = new Set();

    get maxFrames() { return this._maxFrames; };
    get scrollOffset() { return this._scrollOffset; };
    get frameElementWidth() { return timelineContainer.offsetWidth / this.maxFrames; };
    get width() { return this.frameElementWidth * (this.animation || { totalFrames: 0 }).totalFrames; };
    get animation() { return this._animation; };
    get hasAnimation() { return this.animation instanceof ViewportAnimation; };
    
    set maxFrames(value) {
        
        this._maxFrames = value;

        this.instanceFrameElements();
        this.updateKeyframeElementsPosition();
        this.updateCursorElementPosition();
    }

    set scrollOffset(value) {
        this._scrollOffset = clamp(value, 0, this.width - timelineContainer.offsetWidth);
        timelineElement.style.left = `${-this._scrollOffset}px`;
    }

    set animation(value) {

        const actionButtons = [animationLoopCheckbox,animationPreviousFrameButton,animationNextFrameButton,animationPlayButton, timelineElement, currentFrameElement, endFrameElement, fpsElement, deleteAnimationButton, renameAnimationButton];

        if (!(value instanceof ViewportAnimation)) {
            this._animation = null;
            addClassTo(actionButtons, "disabled");
            removeAllChildren(timelineKeyframes);
            return;
        }

        removeClassTo(actionButtons, "disabled");

        value.onFrameReached.addListener(frame => {
            this.updateCursorElementPosition();
            currentFrameElement.value = frame.toString();
        });

        value.onAnimationStarted.addListener(() => animationPlayButton.querySelector("img").src = "icons/pause.svg");
        value.onAnimationEnded.addListener(() => animationPlayButton.querySelector("img").src = "icons/play.svg");
        value.onAnimationStopped.addListener(() => animationPlayButton.querySelector("img").src = "icons/play.svg");

        this._animation = value;

        this.scrollOffset = 0;
        this._maxFrames = Math.min(this._animation.totalFrames, this._maxFrames);

        currentFrameElement.value = value.currentFrame.toString();
        endFrameElement.value = value.totalFrames.toString();
        fpsElement.value = value.fps.toString();
        animationLoopCheckbox.checked = value.loop;

        this.updateScroller();
        this.instanceFrameElements();
        this.instanceKeyframeElements();
    }

    constructor(animation = null) {
        this.animation = animation;

        function checkAndSet(input, propertyName, evName = "input", action = null) {

            const onEvent = e => {
                const value = parseInt(input.value);

                if (isFinite(value) && this.animation instanceof ViewportAnimation) {
                    this.animation[propertyName] = value;
                    if (action) {
                        action();
                    }
                }
            };

            input.addEventListener(evName, onEvent.bind(this));
        }

        checkAndSet = checkAndSet.bind(this);

        checkAndSet(fpsElement, "fps");
        checkAndSet(currentFrameElement, "currentFrame");
        checkAndSet(endFrameElement, "totalFrames", "change", () => {
            this.maxFrames = Math.min(this.animation.totalFrames, this.maxFrames);

            this.updateScroller();
            this.updateKeyframeElementsPosition();
            this.updateCursorElementPosition();
            this.clampScrollOffset();
        });
        
        animationLoopCheckbox.addEventListener("click", e => {
            if (this.animation instanceof ViewportAnimation) {
                this.animation.loop = animationLoopCheckbox.checked;
            }
        });

        timelineElement.addEventListener("click", e => {
            if (e.target.classList.contains("keyframe") && this.hasAnimation) {
                const keyframe = this.animation.getKeyframeByElement(e.target);
                
                if (keyframe instanceof Keyframe) {
                    
                    if (e.shiftKey && !this.selectedKeyframes.has(keyframe)) {
                        this.selectedKeyframes.add(keyframe);
                        keyframe.element.classList.add("selected");

                    } else if (e.shiftKey && this.selectedKeyframes.has(keyframe)) {
                        this.selectedKeyframes.delete(keyframe);
                        keyframe.element.classList.remove("selected");

                    } else {

                        this.selectedKeyframes.forEach(sKeyframe => sKeyframe.element.classList.remove("selected"));
                        this.selectedKeyframes.clear();

                        this.selectedKeyframes.add(keyframe);
                        keyframe.element.classList.add("selected");
                    }

                }

            } else if (!e.shiftKey) {
                this.selectedKeyframes.forEach(sKeyframe => sKeyframe.element.classList.remove("selected"));
                this.selectedKeyframes.clear();
            }
        });

        document.addEventListener("keyup", e => {

            const key = e.key.toLowerCase();

            if (lastMousePosition && lastMousePosition.isInsideOf(timelineContainer)) {
                if (key == "delete" || key == "x" || key == "backspace") {
                    this.selectedKeyframes.forEach(sKyeframe => {
                        sKyeframe.remove();
                    });

                    this.selectedKeyframes.clear();
                }

            }

            if (key == "i" && viewport.selectedInstances.size > 0 && this.hasAnimation) {
                this.createKeyframe();
            }
        });
    }

    updateScroller() {

        if (this.hasAnimation) {
            const scrollerLeft = (timeline.scrollOffset / timeline.width) * timelineScrollerContainer.offsetWidth;
            const scrollerWidth = (timeline.maxFrames / this.animation.totalFrames) * timelineScrollerContainer.offsetWidth;
            timelineScroller.style.right = `${timelineScrollerContainer.offsetWidth - scrollerWidth}px`;
            timelineScroller.style.left = `${scrollerLeft}px`;
        } else {
            timelineScroller.style.right = "0";
            timelineScroller.style.left = "0";
        }


    }

    clampScrollOffset() {
        this.scrollOffset = clamp(this.scrollOffset, 0, this.width - timelineContainer.offsetWidth);
    }

    instanceFrameElements() {
        if (this.animation instanceof ViewportAnimation) {
            removeAllChildren(timelineElement);
            timelineElement.appendChild(timelineOverlay);

            for (let frame = 0; frame < this.animation.totalFrames; frame++) {
                const frameElement = document.createElement("span");
                
                frameElement.classList.add("frame_line");
                frameElement.style.width = `${this.frameElementWidth}px`;

                timelineElement.appendChild(frameElement);
            }
        }
    }

    instanceKeyframeElements() {
        if (this.animation instanceof ViewportAnimation) {
            removeAllChildren(timelineKeyframes);

            this.animation.keyframes.forEach(keyframe => {
                keyframe.element.remove();
                keyframe.element.style.left = `${keyframe.frame * this.frameElementWidth}px`;
                timelineKeyframes.appendChild(keyframe.element);
            });
        }
    }

    updateKeyframeElementsPosition() {
        Array.from(timelineKeyframes.children).forEach(keyframeElement => {
            if (this.animation instanceof ViewportAnimation) {

                const foundKeyframe = this.animation.getKeyframeByElement(keyframeElement);

                if (foundKeyframe) {
                    keyframeElement.style.left = `${foundKeyframe.frame * this.frameElementWidth}px`;
                }
            }
        });
    }

    updateCursorElementPosition() {
        if (this.hasAnimation) {
            if (this.animation.currentFrame > this.animation.totalFrames) {
                this.animation.currentFrame = this.animation.totalFrames;
            }
            timelineCursor.style.left = `${this.animation.currentFrame * this.frameElementWidth}px`;
        }
    }

    /**
     * 
     * @param {?Instance} of 
     */
    createKeyframe(of) {
        let selectedInstances = Array.from(viewport.selectedInstances);

        if (of instanceof Instance) {
            selectedInstances = [of];    
        }

        if (selectedInstances.length < 1) {
            return;
        }

        const newKeyFrame = this.animation.createKeyframeFromInstance(selectedInstances.shift(), this.animation.currentFrame);
        selectedInstances.forEach(instance => newKeyFrame.appendInstanceTransform(instance));

        timelineKeyframes.appendChild(newKeyFrame.element);
        newKeyFrame.element.style.left = `${this.animation.currentFrame * this.frameElementWidth}px`;
    }
}

const timeline = new Timeline();

// function clampTimelineOffset() {
//     timelineScrollOffset = Math.max(Math.min((frameElementWidth*currentAnimation.totalFrames) - timelineContainer.offsetWidth, timelineScrollOffset), 0);
// }

renameAnimationButton.addEventListener("click", e => {
    let newName = prompt("Escriba el nuevo nombre de la animación:", timeline.animation.name);

    if (newName) {
        const otherAnimationsNamedTheSame = Array.from(animations).filter(a => a.name.split(".")[0] === newName && a !== timeline.animation);
        
        if (otherAnimationsNamedTheSame.length > 0) {
            newName += `.${otherAnimationsNamedTheSame.length.toString().padStart(4, "0")}`;
        }

        timeline.animation.name = newName;
        timeline.animation.selectElement.textContent = newName;
    }
    
})

deleteAnimationButton.addEventListener("click", e => {
    animations.delete(timeline.animation);
    timeline.animation.selectElement.remove();
    timeline.animation = null;

    animationSelectElement.value = "";
    animationSelectElement.setAttribute("value", "");
});

createAnimationButton.addEventListener("click", e => {
    nextAnimationId++;

    const animation = new ViewportAnimation("Sin nombre " + (animations.size + 1).toString());
    const optionElement = document.createElement("option");

    animation.id = nextAnimationId;
    optionElement.value = nextAnimationId.toString();
    optionElement.textContent = animation.name;

    animations.add(animation);
    animationSelectElement.appendChild(optionElement);

    animation.selectElement = optionElement;
    timeline.animation = animation;

    optionElement.selected = true;
    animationSelectElement.setAttribute("value", optionElement.value);

    // renameAnimationButton.dispatchEvent(new Event("click"));
    
    // updateFromAnimationToElements();
    // animationSelectElement.dispatchEvent(new Event("change"));
});

animationSelectElement.addEventListener("change", e => {
    const id = parseInt(animationSelectElement.value);
    let foundAnimation = null;
    
    animations.forEach(animation => {
        if (animation.id === id && !foundAnimation) {
            foundAnimation = animation;
        }
    });

    if (foundAnimation instanceof ViewportAnimation) {
        timeline.animation = foundAnimation;
        timeline.animation.selectElement.selected = true;
        animationSelectElement.setAttribute("value", timeline.animation.selectElement.value);
    }
});

animationPlayButton.addEventListener("click", e => {
    if (timeline.hasAnimation) {
        const imageIcon = animationPlayButton.querySelector("img");

        if (timeline.animation.playing) {
            timeline.animation.stop();        
        } else {
            timeline.animation.play();
        }
    }
});


/**
 * @typedef TimelineAction
 * 
 * @property {'move_keyframe'|'move_cursor'|'move_scroller'|'right_expand_scroller'|'left_expand_scroller'} type
 * @property {?Vector} startClientPosition
 * @property {number} startTime
 * @property {?function} onFinished
 */



/**@type {?TimelineAction} */
var timelineAction = null;

/**
 * 
 * @param {TimelineAction} data 
 */
function startTimelineAction(data = null) {
    
    if (data) {
        data.startTime = performance.now();
    }

    timelineAction = data;
}

function finishTimelineAction() {
    if (timelineAction == null) {
        return;
    }

    if (typeof timelineAction.onFinished == "function") {
        timelineAction.onFinished(timelineAction);
    }

    timelineAction = null;
}

["mouseup", "mouseleave"].forEach(eventName => document.addEventListener(eventName, e => finishTimelineAction()));

document.addEventListener("mousemove", e => {
    if (!timelineAction) {
        return;
    }

    const clientPosition = new Vector(e.clientX, e.clientY);
    const timelineScrollerContainerRect = timelineScrollerContainer.getBoundingClientRect();
    const timelineScrollerRect = timelineScroller.getBoundingClientRect();

    let scrollerHaveBeenEdited = false;
        
    switch (timelineAction.type) {
        case 'left_expand_scroller':
            let left = clientPosition.x - timelineScrollerContainerRect.left;
            left = clamp(left, 0, timelineScrollerContainerRect.width);
            timelineScroller.style.left = `${left}px`; 
            scrollerHaveBeenEdited = true;
            break;
        
        case 'right_expand_scroller':
            let right = timelineScrollerContainerRect.right - clientPosition.x;
            right = clamp(right, 0, timelineScrollerContainerRect.width);
            timelineScroller.style.right = `${right}px`;
            scrollerHaveBeenEdited = true;
            break;

        case 'move_scroller':
            timelineScroller.style.left = `${Math.max(0,timelineScroller.offsetLeft + e.movementX)}px`;
            timelineScroller.style.right = `${Math.max(0, timelineScrollerContainerRect.right - timelineScrollerRect.right - e.movementX)}px`; 
            scrollerHaveBeenEdited = true;
            break;
        
        case 'move_cursor':
            const timelineContainerRect = timelineContainer.getBoundingClientRect();
            let newPosition = clientPosition.x - timelineContainerRect.left;

            newPosition = Math.round(newPosition / timeline.frameElementWidth) * timeline.frameElementWidth;
            timelineCursor.style.left = `${clamp(newPosition, 0, timeline.width)}px`;
            timeline.animation.currentFrame = Math.round(timelineCursor.offsetLeft / timeline.frameElementWidth);
            currentFrameElement.value = timeline.animation.currentFrame.toString();

            timeline.animation.step();
            break;
    }

    if (timeline.animation instanceof ViewportAnimation && scrollerHaveBeenEdited) {

        const animationTotalFrames = timeline.animation.totalFrames;
        const frameElementWidth = timeline.frameElementWidth;

        timeline.maxFrames = (timelineScroller.offsetWidth / timelineScrollerContainer.offsetWidth) * animationTotalFrames;
        timeline.scrollOffset = (timelineScroller.offsetLeft / timelineScrollerContainer.offsetWidth) * frameElementWidth * animationTotalFrames;
    }

});

document.addEventListener("mousedown", e => {
   
    const clientPosition = new Vector(e.clientX, e.clientY);
    const rect = timelineScroller.getBoundingClientRect();

    if (clientPosition.isInsideOf(timeline)) {
        
    }

    if (inside(clientPosition.y, rect.top + rect.height * .5, rect.height * .5 + 10) && !timelineAction) {
        
        if (inside(clientPosition.x, rect.left)) {
            startTimelineAction({type: "left_expand_scroller"});
        } else if (inside(clientPosition.x, rect.right)) {
            startTimelineAction({type: "right_expand_scroller"});
        } else if (inside(clientPosition.x, rect.left + rect.width*.5, rect.width*.5 - 10)) {
            startTimelineAction({type: "move_scroller"});
        }

        if (timelineAction) {
            timelineAction.startClientPosition = clientPosition.copy();
        }

    } else if (e.target == timelineCursor || e.target.parentElement == timelineCursor || e.target.classList.contains("frame_line")) {
        startTimelineAction({
            type: "move_cursor",
            startClientPosition: clientPosition.copy()
        });
    }

});

document.addEventListener("wheel", e => {
    const clientPosition = new Vector(e.clientX, e.clientY);
    const timelineRect = timelineContainer.getBoundingClientRect();

    if (inside(clientPosition.y, timelineRect.top + timelineRect.height * .5, timelineRect.height * .5) && inside(clientPosition.x, timelineRect.left + timelineRect.width * .5, timelineRect.width * .5)) {
        timeline.scrollOffset += e.deltaY;
    }
});






