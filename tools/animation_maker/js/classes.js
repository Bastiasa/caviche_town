function lerpAngle (A, B, w){
    let CS = (1-w)*Math.cos(A) + w*Math.cos(B);
    let SN = (1-w)*Math.sin(A) + w*Math.sin(B);
    return Math.atan2(SN,CS);
}

function snap(value, where) {
    return Math.round(value / where) / where;
}



/**
 * @typedef {"px"|"pc"|"fr"|"%"|"cm"|"m"} CSSUnit
 */

class Vector {

    /**
     * @param {number} x
     * @param {number} y
     */

    _x;
    _y;

    get x() { return this._x; }
    get y() { return this._y; }

    set x(givenValue) {
        this._x = givenValue;

        if (typeof this.onValueChanged == "function") {
            this.onValueChanged();            
        }
    }

    set y(givenValue) {
        this._y = givenValue;

        if (typeof this.onValueChanged == "function") {
            this.onValueChanged();
        }
    }

    get rightVector() {
        return new Vector(this.y, -this.x).normalized;
    }

    constructor(x = 0, y = 0) {
        this.x = x;
        this.y = y;

        if (!x) {
            this.x = 0;
        }

        if (!y) {
            this.y = 0;
        }
    }


    /**
     * 
     * @returns {Vector}
     */
    copy() {
        return new Vector(this.x, this.y);
    }

    /**
     * @param {Vector} other 
     * @returns {Vector}
     */
    add(other) {
        return new Vector(this.x + other.x, this.y + other.y);
    }

    /**
     * 
     * @param {Vector} other 
     * @returns {Vector}
     */
    substract(other) {
        return this.add(other.negative);
    }

    /**
     * @param {Vector|number} other 
     * @returns {Vector}
     */
    multiply(other) {

        if (typeof other == "number") {
            return this.multiply(Vector.diagonalVector(other));
        } else if (other instanceof Vector) {
            return new Vector(this.x * other.x, this.y * other.y);
        }
    }

    rotated(angle, mode = "DEG") {
        return Vector.fromMagnitudeAndAngle(this.magnitude, angle, mode);
    }

    /**
     * @param {Vector|number} other 
     * @returns {Vector}
     */
    divide(other) {
        if (typeof other == "number") {
            return this.multiply(Vector.diagonalVector(1 / other));
        } else {
            return this.multiply(new Vector(1 / other.x, 1 / other.y));
        }
    }

    /**
     * 
     * @param {Vector} other 
     * @param {number} factor 
     * @returns 
     */
    lerp(other, factor = 1) {
        return this.add(other.substract(this).multiply(factor));
    }

    /**
     * 
     * @param {Vector} minimun 
     * @param {Vector} maximum
     * @returns {Vector} 
     */
    clamp(minimun, maximum) {
        return new Vector(
            Math.max(Math.min(this.x, maximum.x), minimun.x),
            Math.max(Math.min(this.y, maximum.y), minimun.y)
        );
    }

    sign() {
        return new Vector(Math.sign(this.x), Math.sign(this.y));
    }

    area() {
        return this.x * this.y;
    }

    /**
     * 
     * @param {HTMLElement} element 
     * @param {CSSUnit} unit 
     */
    setElementSize(element, unit = "px") {
        element.style.width = `${this.x}${unit}`;
        element.style.height = `${this.y}${unit}`;
    }

    /**
     * 
     * @param {HTMLElement} element 
     * @param {CSSUnit} unit 
     */
    setElementPosition(element, unit = "px") {
        element.style.left = `${this.x}${unit}`;
        element.style.top = `${this.y}${unit}`;
    }

    /**
     * 
     * @param {Vector} mousePosition 
     * @returns {{"size":Vector, "position":Vector}}
     */
    getSquareTransformByMouse(mousePosition) {
        
        const startPosition = this;
        
        const size = new Vector();
        const position = new Vector();

        if (startPosition.x < mousePosition.x) {
            size.x = mousePosition.x - startPosition.x;
            position.x = startPosition.x;
        } else {
            size.x = startPosition.x - mousePosition.x;
            position.x = mousePosition.x;
        }

        if (startPosition.y < mousePosition.y) {
            size.y = mousePosition.y - startPosition.y;
            position.y = startPosition.y;
        } else {
            size.y =  startPosition.y - mousePosition.y;
            position.y = mousePosition.y;
        }


        return {size, position};
    }

    /**
     * 
     * @param {Vector} size 
     * @returns {DOMRect}
     */
    getBoundingRect(size) {
        return {
            x: this.x,
            left: this.x,
            width: size.x,

            y: this.y,
            top: this.y,
            height: size.y,
            
            right: this.x + size.x,
            bottom: this.y + size.y
        }
    }

    /**
     * 
     * @param {HTMLElement} element 
     * @returns {boolean}
     */
    isInsideOf(element) {

        if (!(element instanceof HTMLElement)) {
            return false;
        }

        const rect = element.getBoundingClientRect();

        const isInX = this.x >= rect.left && this.x < rect.right; 
        const isInY = this.y >= rect.top && this.y < rect.bottom; 

        return isInX && isInY;
    }


    get negative() {
        return new Vector(-this.x, -this.y);
    }

    get magnitude() {
        return Math.sqrt(this.x ** 2 + this.y ** 2);
    }

    set magnitude(newMagnitude) {
        this.x = Math.cos(this.angle) * newMagnitude;
        this.y = Math.sin(this.angle) * newMagnitude;
    }

    get direction() {
        return Math.atan2(this.y, this.x);
    }

    set direction(newAngle) {
        this.localAngle = (newAngle / 180)*Math.PI;
        this.x = Math.cos(this.localAngle) * this.magnitude;
        this.y = Math.sin(this.localAngle) * this.magnitude;
    }
    
    get normalized() {
        return this.divide(this.magnitude);
    }

    set normalized(normalizedVector) {
        let result = this.multiply(normalizedVector);

        this.x = result.x;
        this.y = result.y;
    }

    toString() {
        return `(${this.x}, ${this.y})`;
    }

    static get zero() { return new Vector(0, 0) };
    static get up() { return new Vector(0, 1) };
    static get down() { return new Vector(0, -1) };
    static get left() { return new Vector(-1, 0) };
    static get right() { return new Vector(1, 0) };
    static get topLeft() { return new Vector(-1, 1) };
    static get topRight() { return new Vector(1, 1) };
    static get bottomLeft() { return new Vector(-1, -1) };
    static get bottomRight() { return new Vector(1, -1) };


    /**
     * 
     * @param {HTMLElement} element 
     * @returns {Vector}
     */
    static fromElement(element) {
        return new Vector(element.offsetLeft, element.offsetTop);
    }

    /**
     * 
     * @param {number} magnitude 
     * @param {number} angle 
     * @returns {Vector}
     */
    static fromMagnitudeAndAngle(magnitude, angle, mode = "DEG") {

        if (mode == "DEG") {
            angle = angle / 180 * Math.PI;
        }

        const x = Math.cos(angle) * magnitude;
        const y = Math.sin(angle) * magnitude;

        return new Vector(x, y);
    }

    /**
     * 
     * @param {number} length 
     * @returns {Vector}
     */
    static diagonalVector(length) {
        return new Vector(length, length);
    }
    
    /**
     * 
     * @param {HTMLElement} element 
     * @returns 
     */
    static getOffsetSize(element) {
        return new Vector(element.offsetWidth, element.offsetHeight);
    }

    /**
     * 
     * @param {number} x 
     * @returns {Vector}
     */
    static onlyX(x) {
        return new Vector(x, 0);
    }

    /**
     * 
     * @param {number} y
     * @returns {Vector}
     */
    static onlyY(y) {
        return new Vector(0, y);
    }
}

class Signal {
    /**
     * @param {Set<()=>void>} onFired
     */
    onFired;

    /**
     * 
     * @param {Iterable<()=>void>} listeners 
     */
    constructor(listeners) {
        this.onFired = new Set(listeners);
    }

    /**
     * 
     * @param {(...args)=>void} listener 
     */
    addListener(listener) {
        if (typeof listener != "function") {
            console.error("Add Listener Error: the listener", listener,"is not a function.");
            return;
        }

        this.onFired.add(listener);
    }

    removeListener(listener) {
        this.onFired.delete(listener);
    }

    fire(...args) {
        Array.from(this.onFired).forEach(listener => {
            listener(...args);
        });
    }
}

/**
 * @interface
 * @typedef ActionData
 * 
 * @property {0|1|2|3|4} type - What is the action doing.
 * 
 * 0 - Position set
 * 1 - Scale set
 * 2 - Rotation set
 * 3 - Anchor point set
 * 4 - Create line
 * 
 * @property {?Vector} position - An start position.
 * 
 * @property {?Array<Instance>|?Set<Instance>} targets - The instances affected for the action.
 * @property {?Instance} target - The instance affected for the action.
 * 
 * @property {?boolean} finishOnClick - If active, when the user clicks, the action will have finished.
 * @property {?boolean} finishClickUnfocused - If active, the click must be in an empty space from the viewport.
 * @property {?boolean} finishClickInside - If active, the click must be inside to be finished.
 * 
 * @property {?boolean} reset - If active, when this action is called again, will be cancelled and restarted.
 * @property {number} startTime - The time when this action was started.
 * 
 * @property {?((action:ActionData)=>void)} onCancelled - Executed when the action is cancelled.
 * @property {?((action:ActionData)=>void)} onFinished - Executed when changes applied.
 * 
 * ...
 * 
 * Any other params you need.
 * 
 */

/**
 * @class
 * @property {?HTMLElement} element
 * @property {?Vector} onActionStartedMousePosition
 * @property {?Vector} lastMousePosition
 * @property {Vector} position
 * @property {number} scale
 * @property {boolean} isHoldingWheel
 * @property {?ActionData} action
 * 
 * @property {Set<Instance>} selectedInstances
 * @property {Set<Instance>} instances
 */
class Viewport {

    static ACTION_NONE = -1

    static ACTION_POSITION_SET = 0
    static ACTION_SCALE_SET = 1
    static ACTION_ROTATION_SET = 2
    static ACTION_ANCHOR_POINT_SET = 3
    static ACTION_CREATE_LINE = 4
    static ACTION_SELECT = 5

    element;

    lastMousePosition = new Vector();

    instances = new Set();
    selectedInstances = new Set();

    position = new Vector();
    scale = 1;

    isHoldingWheel = false;
    isHoldingLMB = false;

    onInstanceRemoved = new Signal();
    onInstanceAdded = new Signal();

    onInstaceSelected = new Signal();
    onInstaceDeselected = new Signal();

    deselectOnClick = true;

    defaultActions = {
        setSelectedInstancesPosition: () => {
            if (this.isCurrentAction(Viewport.ACTION_POSITION_SET)) {
                this.cancelCurrentAction();
            } else {
                this.startAction({
                    type: Viewport.ACTION_POSITION_SET,
                    targets: Array.from(this.selectedInstances),
                    finishOnClick: true
                });
            }
        },

        setLastSelectedInstanceRotation: () => {
            if (this.isCurrentAction(Viewport.ACTION_ROTATION_SET)) {
                this.cancelCurrentAction();
            } else {
                
                const target = Array.from(this.selectedInstances)[this.selectedInstances.size - 1];

                this.startAction({
                    type: Viewport.ACTION_ROTATION_SET,
                    finishOnClick: true,
                    target,
                    position: this.mousePosition.copy(),
                    rotation: target.rotation
                });
            }
        },
        
        setSelectedInstancesScale: () => {
            if (this.isCurrentAction(Viewport.ACTION_SCALE_SET)) {
                this.cancelCurrentAction();
            } else {
                const action = {
                    type: Viewport.ACTION_SCALE_SET,
                    targets: Array.from(this.selectedInstances),
                    finishOnClick: true,
                    scales: [],
                    scale : 1,
                    position: this.mousePosition.copy(),
                    center:this.getBottomLeftSelectedInstance().position.add(this.getTopRightSelectedInstance().position).multiply(.5)
                };

                action.targets.forEach(instance => {
                    action.scales.push({ "scale": instance.scale, "instance": instance });
                });

                this.startAction(action);
            }
        }

    }

    /**@type {?ActionData} */
    action;

    get selectedElementsCentralPosition() {
        if (this.selectedInstances.size > 0) {
            return this.getBottomLeftSelectedInstance().position.add(this.getTopRightSelectedInstance().position).multiply(.5);
        }

        return null
    }


    documentEvents = {

        /**@param {MouseEvent} event @this {Viewport} */
        onDocumentClick: function (event) {
            
            if (this.isMouseInViewport() && this.deselectOnClick && !event.target.classList.contains("instance") && !this.action) {
                this.deselectAllInstances();
            }

            if (this.action && this.action.finishOnClick && performance.now() - this.action.startTime > 2.0) {

                const unfocused = event.target == this.element.parentElement;
                const inside = this.isMouseInViewport();

                if ((this.action.finishClickInside && !inside) || (this.action.finishClickUnfocused && !unfocused)) {
                } else {
                    this.finishAction();                                    
                }
            }
        },

        /**@param {MouseEvent} event @this {Viewport} */
        onDocumentMouseDown: function (event) {
            if (event.button == 1) {
                this.isHoldingWheel = true;
            } else if (event.button == 0) {
                this.isHoldingLMB = true;

                
                if (event.target.classList.contains("anchor-dot")) {
                    const foundInstance = this.getInstanceByAnchorDotElement(event.target);

                    if (foundInstance instanceof Instance) {
                        document.body.style.cursor = "grabbing";

                        foundInstance.positionAnchored = false;

                        this.startAction({
                            type: Viewport.ACTION_ANCHOR_POINT_SET,
                            target: this.getInstanceByAnchorDotElement(event.target),
                            position: foundInstance.position.copy(),
                            oldValue:foundInstance.anchorPoint.copy(),

                            onCancelled: (action) => {
                                foundInstance.anchorPoint = action.oldValue;
                                foundInstance.positionAnchored = true;
                            },

                            onFinished: action => {
                                // foundInstance.anchorPoint = foundInstance.anchorPoint.rotated(foundInstance.anchorPoint.direction - foundInstance.rotation, "rad");
                                const anchorDotRotation = foundInstance.anchorPoint.direction * (180/Math.PI);

                                console.log(foundInstance.degreeRotation, anchorDotRotation, foundInstance.anchorPoint);//foundInstance.degreeRotation - anchorDotRotation);

                                foundInstance.anchorPoint = foundInstance.anchorPoint;
                                foundInstance.positionAnchored = true;

                                console.log(foundInstance.anchorPoint.direction * (180/Math.PI));
                                
                            }
                        
                        });
                    }
                    


                }
            }


        },

        /**@param {MouseEvent} event @this {Viewport} */
        onDocumentMouseUp:function (event) {
            if (event.button == 1) {
                this.isHoldingWheel = false;
            } else if (event.button == 0) {

                this.isHoldingLMB = false;

                if (this.isCurrentAction(Viewport.ACTION_ANCHOR_POINT_SET)) {
                    this.finishAction();
                    document.body.style.cursor = "unset";
                }

                if (this.isCurrentAction(Viewport.ACTION_SELECT)) {
                    this.finishAction();
                }
            }
        },

        /**@param {MouseEvent} event @this {Viewport} */
        onDocumentMouseMotion: function (event) {

            const mouseMotion = new Vector(event.movementX, event.movementY);

            if (this.element.parentElement) {
                this.lastMousePosition = new Vector(event.clientX, event.clientY);
            }

            if (!this.action && this.isHoldingLMB) {
                const selectionSquare = document.createElement("div");
                selectionSquare.classList.add("selection_square");
                
                this.mousePosition.setElementPosition(selectionSquare);
                this.element.appendChild(selectionSquare);

                function removeSelectionSquare() {
                    selectionSquare.classList.add("eliminated");
                    setTimeout(() => selectionSquare.remove(), 300);
                }

                this.startAction({
                    type: Viewport.ACTION_SELECT,
                    targets: new Set(),

                    onFinished: action => {
                        this.deselectAllInstances();
                        document.addEventListener("click", (e => this.deselectOnClick = true).bind(this), { once: true });

                        this.deselectOnClick = false;
                        action.targets.forEach(this.selectInstance.bind(this));
                        removeSelectionSquare();
                    },

                    onCancelled: action => {
                        action.targets.forEach(target => target.classList.remove("selected"));
                        removeSelectionSquare();
                    },

                    position: this.mousePosition.copy(),
                    selectionSquare,
                });
            }

            if (this.isHoldingWheel && this.isMouseInViewport()) {
                this.position = this.position.add(mouseMotion.divide(this.scale));
            }

            if (this.isCurrentAction(Viewport.ACTION_CREATE_LINE) && this.action.line instanceof LineInstance) {
                
                /**@type {LineInstance} */
                const line = this.action.line;
                const centeredMousePosition = this.mousePosition.substract(line.position);

                line.length = centeredMousePosition.magnitude - 2;
                line.rotation = centeredMousePosition.direction;

                if (event.shiftKey) {
                    line.degreeRotation = Math.round(line.degreeRotation / 15) * 15;
                }

            }

            if (this.isCurrentAction(Viewport.ACTION_POSITION_SET) && this.isMouseInViewport()) {

                this.action.targets.forEach(instance => {
                    instance.position = instance.position.add(mouseMotion.divide(this.scale));
                });

                if (event.shiftKey && this.action.targets.length === 1) {
                    /**@type {?Instance} */
                    let nearestInstance;
                    /**@type {Instance} */
                    const target = this.action.targets[0];

                    this.instances.forEach(instance => {

                        if (instance === target) {
                            return;
                        }

                        if (!nearestInstance) {
                            nearestInstance = instance;
                        }

                        const position = target.position;

                        if (position.substract(nearestInstance.position).magnitude > position.substract(instance.position).magnitude) {
                            nearestInstance = instance;
                        }
                    });

                    console.log(nearestInstance);
                    

                    if (nearestInstance instanceof Instance) { 
                        const nearestRect = nearestInstance.getBoundingRect();
                        const targetRect = target.getBoundingRect();

                        const differenceRect = {
                            left:nearestRect.left-targetRect.left,
                            right: nearestRect.right - targetRect.right,
                            
                            top:nearestRect.top-targetRect.top,
                            bottom: nearestRect.bottom - targetRect.bottom,
                            
                            topAndBottom: nearestRect.top - targetRect.bottom,
                            BottomAndTop: nearestRect.bottom - targetRect.top,

                            leftAndRight: nearestRect.left - targetRect.right,
                            rightAndLeft: nearestRect.right - targetRect.left,

                        }

                        const distanceDifference = 5 / this.scale;

                        function between(value, range = distanceDifference) {
                            return Math.max(-range, Math.min(range, value)) === value;
                        }


                        if (between(differenceRect.top)) {
                            target.position.y = nearestRect.top;
                            target.position.y += targetRect.height * target.anchorPoint.y;
                        } else if (between(differenceRect.bottom)) {
                            target.position.y = nearestRect.bottom;
                            target.position.y -= targetRect.height * target.anchorPoint.y;
                        } else if (between(differenceRect.topAndBottom)) {
                            target.position.y = nearestRect.top;
                            target.position.y -= targetRect.height * target.anchorPoint.y;
                        } else if (between(differenceRect.BottomAndTop)) {
                            target.position.y = nearestRect.bottom;
                            target.position.y += targetRect.height * target.anchorPoint.y;
                        }

                        if (between(differenceRect.left)) {
                            target.position.x = nearestRect.left;
                            target.position.x += targetRect.width * target.anchorPoint.x;
                        } else if (between(differenceRect.right)) {
                            target.position.x = nearestRect.right;
                            target.position.x -= targetRect.width * target.anchorPoint.x;
                        } else if (between(differenceRect.leftAndRight)) {
                            target.position.x = nearestRect.left;
                            target.position.x -= targetRect.width * target.anchorPoint.x;
                        } else if (between(differenceRect.rightAndLeft)) {
                            target.position.x = nearestRect.right;
                            target.position.x += targetRect.width * target.anchorPoint.x;
                        }
                    }
                }
                
            }

            if (this.isCurrentAction(Viewport.ACTION_ROTATION_SET) && this.isMouseInViewport()) {
                const centeredMousePosition = this.mousePosition.substract(this.action.target.position);
                const startPosition = this.action.position.substract(this.action.target.position);

                const dot = startPosition.x * centeredMousePosition.x + startPosition.y * centeredMousePosition.y;
                const cosTheta = dot / (startPosition.magnitude * centeredMousePosition.magnitude);
                
                const cross = startPosition.x * centeredMousePosition.y - startPosition.y * centeredMousePosition.x;
                const sign = (cross < 0 ? -1 : 1);

                let angle =  sign * Math.acos(cosTheta);
                const degreeAngle = angle * (180 / Math.PI);

                if (event.shiftKey) {
                    angle = Math.round(degreeAngle / 15) * 15 * (Math.PI / 180);
                }

                this.action.target.rotation = this.action.rotation + angle;

                if (event.ctrlKey) {
                    this.action.target.degreeRotation = Math.round(this.action.target.degreeRotation / 15) * 15
                }
            }

            if (this.isCurrentAction(Viewport.ACTION_SCALE_SET) && this.isMouseInViewport()) {


                const centeredMousePosition = this.mousePosition.substract(this.action.center);
                const startPosition = this.action.position.substract(this.action.center);

                this.action.scale = (centeredMousePosition.magnitude / startPosition.magnitude) - 1;

                if (event.shiftKey) {
                    this.action.scale *= .25
                    console.log(this.action.scale);
                    
                }
                

                this.action.scales.forEach(scaleInfo => {
                    scaleInfo.instance.scale = scaleInfo.scale + this.action.scale / this.scale;

                    if (event.ctrlKey) {
                        scaleInfo.instance.scale = snap(scaleInfo.instance.scale*100, 25) / this.scale;
                        
                    }
                });
            }

            if (this.isCurrentAction(Viewport.ACTION_SELECT)) {

                const transform = this.action.position.getSquareTransformByMouse(this.mousePosition);

                transform.position.setElementPosition(this.action.selectionSquare);
                transform.size.setElementSize(this.action.selectionSquare);

                const squareRect = transform.position.getBoundingRect(transform.size);
                

                const dots = this.action.dots;

                this.instances.forEach(
                    
                    /**
                     * 
                     * @param {Instance} instance 
                     */
                    instance => {
                        // const size = Vector.getOffsetSize(instance.element).multiply(instance.scale);
                        // const position = instance.position.substract(size.multiply(instance.anchorPoint));

                        const instanceRect = instance.getBoundingRect();

                        const isTouching = !(
                            instanceRect.right < squareRect.left || // el1 está a la izquierda de el2
                            instanceRect.left > squareRect.right || // el1 está a la derecha de el2
                            instanceRect.bottom < squareRect.top || // el1 está arriba de el2
                            instanceRect.top > squareRect.bottom    // el1 está abajo de el2
                        );

                        if (isTouching) {    
                            this.action.targets.add(instance);
                            instance.element.classList.add("selected");
                        } else {
                            instance.element.classList.remove("selected");
                            this.action.targets.delete(instance);
                        }
                    }
                );
            }

            if (this.isCurrentAction(Viewport.ACTION_ANCHOR_POINT_SET) && this.isMouseInViewport()) {
                const target = this.action.target;
                const size = Vector.getOffsetSize(target.element).multiply(target.scale);
                const anchorPoint = this.mousePosition.substract(target.position).divide(size);

                // target.position = this.action.position.substract(size);
                target.anchorPoint = anchorPoint;

                this.showDotAt(target.position);
                this.showDotAt(target.position.add(size));
            }


        },

        /**@param {WheelEvent} event @this {Viewport} */
        onDocumentWheel: function (event) {
               
            if (!this.element.parentElement) {
                return;
            }

            let toAdd = event.deltaY * (1 / -1000) * this.scale

            if (event.shiftKey) {
                toAdd *= 1.5;
            } else if (event.ctrlKey) {
                toAdd *= .25;
            }

            if (this.isMouseInViewport()) {
                event.preventDefault();

                this.scale += toAdd;
                this.scale = Math.max(0.02, this.scale);
            }


        },

        /**@param {KeyboardEvent} event @this {Viewport} */
        onDocumentKeyPress: function (event) {

            if (event.key == "escape") {
                this.cancelCurrentAction();
            }

            if (this.selectedInstances.size > 0) {

                if (event.key == "g" && this.isMouseInViewport()) {
                    this.defaultActions.setSelectedInstancesPosition();
                }

                if (event.key == "r" && this.isMouseInViewport()) {
                    this.defaultActions.setLastSelectedInstanceRotation();
                }

                if (event.key == "s" && this.isMouseInViewport()) {
                    this.defaultActions.setSelectedInstancesScale();
                }

            }
        },

        /**@param {KeyboardEvent} event @this {Viewport} */
        onDocumentKeyUp: function (event) {

            const key = event.key.toLowerCase() 
            
            if (key == "escape") {
                this.cancelCurrentAction();
            }

            if ((key == "backspace" || key == "delete" || key == "x") && this.selectedInstances.size > 0) {
                Array.from(this.selectedInstances).forEach(instance => this.removeInstance(instance));
            }
        },

    }


    /**
     * 
     * @param {HTMLElement} element 
     */
    constructor(element) {
        this.element = element;

        this.mousePosition = new Vector();

        document.addEventListener("click", this.documentEvents.onDocumentClick.bind(this));
        document.addEventListener("keypress", this.documentEvents.onDocumentKeyPress.bind(this));
        document.addEventListener("keyup", this.documentEvents.onDocumentKeyUp.bind(this));

        document.addEventListener("mousedown", this.documentEvents.onDocumentMouseDown.bind(this));
        document.addEventListener("mouseup", this.documentEvents.onDocumentMouseUp.bind(this));
        document.addEventListener("mousemove", this.documentEvents.onDocumentMouseMotion.bind(this));

        document.addEventListener("wheel", this.documentEvents.onDocumentWheel.bind(this), {passive:false});

        this.updatePositionAndZoomLoop();

        /**
         * @param {MouseEvent} e 
         */
        function mousePositionInViewportEvent(e) {

            if (!this.element.parentElement) {
                return;
            }

            const rect = viewport.element.parentElement.getBoundingClientRect();

            let position = new Vector(e.clientX, e.clientY);
            const clientPosition = position.copy();

            position = position.substract(new Vector(rect.left, rect.top))
            position = position.substract(Vector.getOffsetSize(viewportContainer).multiply(.5));
            position = position.divide(Math.max(Number.MIN_VALUE, viewport.scale))
            position = position.substract(viewport.position);

            this.mousePosition = position;

        }

        ["mousemove", "mouseenter", "mouseleave", "click", "mousedown", "mouseup", "wheel"].forEach(eventName => { document.addEventListener(eventName, mousePositionInViewportEvent.bind(this)) });
    }

    showDotAt(position) {
        const newDot = document.createElement("div");
        newDot.classList.add("anchor-dot");
        this.element.appendChild(newDot);
        position.setElementPosition(newDot);
        return newDot;
    }

    isCurrentAction(actionType) {
        return this.action && this.action.type == actionType;
    }

    getCurrentActionValue(name) {
        if (typeof this.currentActionData != "object") {
            return;
        }

        return this.currentActionData[name];

    }

    isMouseInViewport() {
        if (!this.element.parentElement || !this.lastMousePosition) {
            return false
        } else {
            return this.lastMousePosition.isInsideOf(this.element.parentElement);
        }
    }

    updatePositionAndZoomLoop() {

        if (!this.element.parentElement) {
            return;
        }

        const parentSize = Vector.getOffsetSize(this.element.parentElement);

        this.element.style.left = `${this.position.x + parentSize.x * .5}px`;
        this.element.style.top = `${this.position.y + parentSize.y * .5}px`;

        this.element.style.transformOrigin = `${-this.position.x}px ${-this.position.y}px`;

        this.element.style.scale = `${this.scale}`;

        Array.from(this.instances).forEach(instance => {
            instance.element.style.outlineWidth = `${3/(this.scale*instance.scale)}px`;
            instance.anchorDot.style.width = `${16/this.scale}px`;
            instance.anchorDot.style.height = `${16/this.scale}px`;
        });

        this.element.style.setProperty("--scale", this.scale.toString());

        requestAnimationFrame(this.updatePositionAndZoomLoop.bind(this));
    }

    finishAction() {
        console.log("Action finished after",performance.now() - (this.action||{startTime:performance.now()}).startTime,"\nAction:", this.action);

        if (!this.action) {
            return;
        }

        if (typeof this.action.onFinished == "function") {
            this.action.onFinished(this.action);
        }

        this.action = null;
    }

    /**
     * @param {ActionData} action 
     */
    startAction(action) {

        if (this.action && this.action.reset) {
            this.cancelCurrentAction();
        } else {
            this.finishAction();
        }

        action.startTime = performance.now();


        function makeOnCancelledWithProperty(propertyName) {
            const oldValues = [];

            const addValue = sInstance => {
                let value = sInstance[propertyName];

                if (value instanceof Vector) {
                    value = value.copy();
                }

                oldValues.push({ instance: sInstance, value });
            }

            if (action.targets) {
                action.targets.forEach(addValue);
            } else if (action.target instanceof Instance) {
                addValue(action.target);
            }
            
            action.onCancelled = () => {
                oldValues.forEach(info => { info.instance[propertyName] = info.value });
            }
        }

        switch (action.type) {
            case Viewport.ACTION_POSITION_SET:
                makeOnCancelledWithProperty("position");
                break;
            
            case Viewport.ACTION_ROTATION_SET:
                makeOnCancelledWithProperty("rotation");
                break;

            case Viewport.ACTION_ANCHOR_POINT_SET:
                makeOnCancelledWithProperty("scale");
                break;
        
            default:
                break;
        }

        this.action = action;
        console.log("Action started:", action);
    }

    cancelCurrentAction() {

        if (!this.action) {
            return;
        }

        console.log("Action cancelled:", this.currentAction);

        const onActionCancelled = this.action.onCancelled;

        if (typeof onActionCancelled == "function") {
            onActionCancelled(this.action);
        }

        this.action = null;
    }

    /**@returns {Instance} */
    getBottomLeftSelectedInstance() {

        if (this.instances.size < 1) {
            return null
        }

        const array = Array.from(this.selectedInstances);

        return array.reduce(
            /**
             * 
             * @param {Instance} pInstance 
             * @param {Instance} cInstance 
             */
            (pInstance, cInstance) => {
            
                if (pInstance.position.y < cInstance.position.y) {
                    return cInstance;
                }

                if (cInstance.position.y === pInstance.position.y && cInstance.position.x < pInstance.position.x) {
                    return cInstance;
                }

                return pInstance;
                
            });
    }

    /**@returns {Instance} */
    getTopRightSelectedInstance() {

        if (this.selectedInstances.size < 1) {
            return null;
        }

        const array = Array.from(this.selectedInstances);

        return array.reduce(
            /**
             * 
             * @param {Instance} pInstance 
             * @param {Instance} cInstance 
             */
            (pInstance, cInstance) => {
            
                if (pInstance.position.y > cInstance.position.y) {
                    return cInstance;
                }

                if (cInstance.position.y === pInstance.position.y && cInstance.position.x > pInstance.position.x) {
                    return cInstance;
                }

                return pInstance;
                
            });
    }

    /**
     * 
     * @param {number} index 
     * @returns {Instance}
     */
    getSelectedInstance(index) {
        return Array.from(this.selectedInstances)[index];
    }

    /**
     * 
     * @param {Instance} instance 
     * @returns {boolean}
     */
    isInstanceSelected(instance) {
        return this.selectedInstances.has(instance);
    }

    /**
     * 
     * @param {Instance} instanceToSelect 
     * @returns 
     */
    selectInstance(instanceToSelect) {
        if (!instanceToSelect instanceof Instance) {
            console.warn("ViewportSelect: The given value,",instanceToSelect,"is not an instance.");
            return;
        } 

        if (!this.instances.has(instanceToSelect)) {
            console.warn("ViewportSelect: The given instance,",instanceToSelect,"is not in this viewport.");
            return;
        }

        if (this.selectedInstances.has(instanceToSelect)) {
            return;
        }

        instanceToSelect.element.classList.add("selected");
        instanceToSelect.setAnchorDotVisible(true);
        const selectionIndex = this.selectedInstances.add(instanceToSelect).size - 1;
        this.onInstaceSelected.fire(instanceToSelect, selectionIndex);
    }

    /**
     * 
     * @param {Instance} instanceToDeselect 
     * @returns 
     */
    deselectInstance(instanceToDeselect) {
        if (!instanceToDeselect instanceof Instance) {
            console.warn("ViewportDeselect: The given value,",instanceToDeselect,"is not an instance.");
            return;
        } 

        if (this.selectedInstances.has(instanceToDeselect)) {
            this.selectedInstances.delete(instanceToDeselect);
            instanceToDeselect.element.classList.remove("selected");
            instanceToDeselect.setAnchorDotVisible(false);
            this.onInstaceDeselected.fire(instanceToDeselect);
        }

        if (!this.instances.has(instanceToDeselect)) {
            console.warn("ViewportDeselect: The given instance,",instanceToDeselect,"is not in this viewport.");
            return;
        }
    }

    selectOrDeselectInstance(instance) {
        if (this.isInstanceSelected(instance)) {
            this.deselectInstance(instance);
        } else {
            this.selectInstance(instance);
        }
    }

    deselectAllInstances() {
        this.selectedInstances.forEach(instance => {
            this.deselectInstance(instance);
        });
    }

    /**
     * 
     * @param {Instance} instance 
     * @returns {number} Id of the instance
     */
    appendInstance(instance) {

        if (instance.viewport instanceof Viewport) {
            instance.viewport.removeInstance(instance);
        }

        instance.viewport = this;
        instance.updateTransform();
        this.element.appendChild(instance.element);
        
        const instanceIndex = this.instances.add(instance).size - 1;

        instance.name = instance.constructor.instanceName.toLowerCase() + `#${instanceIndex}`;
        instance.index = instanceIndex;

        this.onInstanceAdded.fire(instance, instanceIndex);

        return instanceIndex;
    }

    /**
     * 
     * @param {Instance} instance 
     */
    removeInstance(instance) {

        if (!(instance instanceof Instance)) {
            console.error("ViewportRemoveChildError: The child", instance, "is not a valid instance.");
            return;
        }

        if (this.isInstanceSelected(instance)) {
            this.deselectInstance(instance);   
        }

        this.instances.delete(instance);

        instance.anchorDot.remove();
        instance.element.remove();
        instance.viewport = undefined;

        this.onInstanceRemoved.fire(instance);
    }


    /**
     * 
     * @param {HTMLElement} element 
     * @returns {Instance}
     */
    getInstanceByElement(element) {
        if (this.instances.size <= 0) {
            return null;
        }

        let result = null

        this.instances.forEach((instance) => {
            if (result) {
                return;
            }

            if (instance.element === element) {
                result = instance;
            }
        });

        return result;
    }

    /**
     * 
     * @param {HTMLElement} anchorDot 
     * @returns {Instance}
     */
    getInstanceByAnchorDotElement(anchorDot) {
        if (this.instances.size <= 0) {
            return null;
        }

        let result = null

        this.instances.forEach((instance) => {
            if (result) {
                return;
            }

            if (instance.anchorDot === anchorDot) {
                result = instance;
            }
        });

        return result;
    }

    /**
     * 
     * @param {number} index 
     * @returns {Instance}
     */
    getInstance(index) {
        return Array.from(this.instances)[index];
    }

}

class Instance {

    static instanceName = "Empty"

    /**@param {Viewport?} viewport*/

    static COLOR_RED = [255, 0, 0];
    static COLOR_GREEN = [0, 255, 0];
    static COLOR_BLUE = [0, 0, 255];
    static COLOR_PURPLE_HUD = [119, 98, 255, 0.645];

    _name = "";
    _element;
    _position;
    _rotation;
    _anchorPoint;
    _scale;
    _size;
    _positionAnchored = true;

    get name() { return this._name; };
    get element() { return this._element; }
    get position() {return this._position;}
    get rotation() { return this._rotation; }
    get degreeRotation() { return this._rotation / Math.PI * 180; }
    get anchorPoint() { return this._anchorPoint };
    get scale() { return this._scale };
    get size() { return this._size };
    get positionAnchored(){return this._positionAnchored};

    set name(newName) {
        this._name = newName;
        
        if (this.element instanceof HTMLElement) {
            this.element.title = this.name;
        }
    }

    set element(givenValue) {
        if (!(givenValue instanceof HTMLElement)) {
            console.error("InstanceElementError: the given value,", givenValue, "is not a HTMLElement.");
            return;
        }

        this._element = givenValue;
        this._element.addEventListener("click", this.onElementClicked.bind(this));
        this._element.title = this.name;
        this.updateTransform();
    }

    set position(givenValue) {

        if (!(givenValue instanceof Vector)) {
            console.error("InstancePositionError: invalid position", givenValue,"is not Vector.");
            return;
        }

        this._position = givenValue;
        this._position.onValueChanged = this.updateTransform.bind(this);

        this.updateTransform();
    }

    set rotation(givenValue) {
        if (typeof givenValue != "number") {
            console.error("InstanceRotationError: the given rotation", givenValue," is not a number.");
            return;
        } else if (!isFinite(givenValue)) {
            return;
        }

        this._rotation = givenValue;
        this.updateTransform();
    }

    set degreeRotation(givenValue) { this.rotation = givenValue / 180 * Math.PI;}
    
    set anchorPoint(givenValue) {
        if (!(givenValue instanceof Vector)) {
            console.error("InstanceAnchorPointError: invalid anchor point,", givenValue,"is not a Vector.");
            return;
        }

        this._anchorPoint = givenValue;
        this._anchorPoint.onValueChanged = this.updateTransform.bind(this);

        this.updateTransform();
    }

    set scale(givenValue) {
        if (typeof givenValue != "number") {
            console.error("InstanceScaleError: the given rotation", givenValue," is not a number.");
            return;
        } else if (!isFinite(givenValue)) {
            return;
        }

        this._scale = givenValue;
        this._scale = Math.max(this._scale, 0.01);
        this.updateTransform();
    }

    set size(givenValue) {
        if (!(givenValue instanceof Vector)) {
            console.error("InstancePositionError: invalid position", givenValue,"is not Vector.");
            return;
        }

        this._size = givenValue;
        this._size.onValueChanged = this.updateTransform.bind(this);

        this.updateTransform();
    }

    set positionAnchored(givenValue) {
        this._positionAnchored = givenValue == true;
        const movement = Vector.getOffsetSize(this.element).multiply(this.anchorPoint).multiply(this.scale);

        if (!this._positionAnchored) {
            // this.position = this.position.substract(Vector.getOffsetSize(this.element).multiply(this.anchorPoint).multiply(this.scale));
            
            this.moveRight(-movement.x);
            this.moveDown(-movement.y);

        } else {
            // this.position = this.position.add(Vector.getOffsetSize(this.element).multiply(this.anchorPoint).multiply(this.scale));

            this.moveRight(movement.x);
            this.moveDown(movement.y);
        }

        this.updateTransform();
    }

    get rightVector() {
        return Vector.fromMagnitudeAndAngle(1, this.rotation, "rad");
    }

    get upVector() {
        return Vector.fromMagnitudeAndAngle(1, this.degreeRotation - 90, "DEG");
    }


    moveRight(amount = 1) {
        this.position = this.position.add(this.rightVector.multiply(amount));
    }

    moveLeft(amout = 1) {
        this.position = this.position.substract(this.rightVector.multiply(amout));
    }

    moveUp(amout = 1) {
        this.position = this.position.add(this.upVector.multiply(amout));
    }

    moveDown(amout = 1) {
        this.position = this.position.substract(this.upVector.multiply(amout));
    }

    updateTransform() {

        if (!(this.element instanceof HTMLElement)) {
            return;
        }
        
        if (this.positionAnchored) {
            this.position.substract(Vector.getOffsetSize(this.element).multiply(this.anchorPoint)).setElementPosition(this.element);
        } else {
            this.position.setElementPosition(this.element);
        }
        
        // this.element.style.left = (this.position.x - this.size.x * this.anchorPoint.x).toString() + "px";
        // this.element.style.top = (this.position.y - this.size.y * this.anchorPoint.y).toString() + "px";

        this.element.style.rotate = this.rotation.toString() + "rad";
        this.element.style.scale = this.scale.toString();

        if (this.positionAnchored) {
            this.element.style.transformOrigin = `${this.anchorPoint.x * 100}% ${this.anchorPoint.y * 100}%`;        
        } else {
            this.element.style.transformOrigin = "0 0";
        }
        
        this.setAnchorDotVisible(this.element.classList.contains("selected"));

        if (!this.positionAnchored) {
            this.position.add(Vector.getOffsetSize(this.element).multiply(this.scale).multiply(this.anchorPoint)).setElementPosition(this.anchorDot);
        } else {
            this.position.setElementPosition(this.anchorDot);
        }
        
    }

    setAnchorDotVisible(visible = false) {
        this.anchorDot.remove();

        if (visible) {
            this.element.parentElement.appendChild(this.anchorDot);
        }
    }

    /**
     * 
     * @param {MouseEvent} event 
     */
    onElementClicked(event) {

        console.log(".");
        

        if (this.viewport instanceof Viewport && !this.viewport.action) {

            const wasSelected = this.viewport.isInstanceSelected(this);

            if (wasSelected && event.shiftKey) {
                this.viewport.deselectInstance(this);
            } else if (event.shiftKey) {
                this.viewport.selectInstance(this);
            } else if (!event.shiftKey) {
                this.viewport.deselectAllInstances();
                this.viewport.selectInstance(this);
            }

            this.setAnchorDotVisible(this.element.classList.contains("selected"));
        }
    }

    removeFromViewport() {
        if (this.viewport instanceof Viewport) {
            this.viewport.removeInstance(this);
        }
    }

    /**
     * 
     * @returns {DOMRect}
     */
    getBoundingRect() {
        const size = Vector.getOffsetSize(this.element).multiply(this.scale);
        const position = this.position.substract(size.multiply(this.anchorPoint));
        return position.getBoundingRect(size);
    }

    constructor(position = new Vector(), rotation = 0, anchorPoint = new Vector(), scale = 1, size = new Vector()) {
        this._position = position;
        this._rotation = rotation;
        this._anchorPoint = anchorPoint;
        this._scale = scale;
        this._size = size;

        this.updateTransform();

        this.position = this._position;
        this.rotation = this._rotation;
        this.anchorPoint = this._anchorPoint;
        this.scale = this._scale;
        this.size = this._size;

        this.anchorDot = document.createElement("div");
        this.anchorDot.classList.add("anchor-dot");

        /**
         * 
         * @param {MouseEvent} event 
         */
        function onMouseEnterOrLeaveAnchorDotElement(event) {
            if (this.viewport instanceof Viewport) {
                if (!this.viewport.action) {
                    

                    if (event.type == "mouseenter") {
                        document.body.style.cursor = "grab";
                    } else {
                        document.body.style.cursor = "unset";
                    }

                }
            }
        }

        ["mouseenter", "mouseleave"].forEach(eventName => {
            this.anchorDot.addEventListener(eventName, onMouseEnterOrLeaveAnchorDotElement.bind(this)); 
        });
    }
}

class ImageInstance extends Instance {

    /**@param {Image?} element */

    onImageLoadedListeners = [];

    static instanceName = "Image"

    _src;
    _viewport;

    get viewport() { return this._viewport; }
    get src() {return this._src;}

    set src(givenValue) {
        this._src = givenValue;

        if (this.element instanceof Image) {
            this.element.src = givenValue;
        }
    }

    set viewport(givenValue) {
        this._viewport = givenValue;
        this.element.src = this._src;
    }

    onImageElementLoaded(event) {
        this.size = new Vector(this.element.width, this.element.height);

        this.onImageLoadedListeners.forEach(listener => {
            listener(event);
        });
    }

    constructor(src, position = new Vector(), rotation = 0, anchorPoint = Vector.diagonalVector(.5), scale = 1) {
        
        super(position, rotation, anchorPoint, scale);

        if (typeof src != "string") {
            console.error("ImageInstance: No src value given to create.");
            return;
        } else if (src.length < 1) {
            console.warn("ImageInstance: The given src is empty.");
        }

        this.element = new Image();
        this.element.addEventListener("load", this.onImageElementLoaded.bind(this));
        this.element.classList.add("instance");

        this._src = src;
    }
}

class LineInstance extends Instance {

    static instanceName = "Line"

    get length() { return this._length };
    get thickness() { return this._thickness };
    get color() { return this._color };

    set length(givenValue) {

        if (typeof givenValue != "number") {
            console.error("LineInstanceLengthError: invalid length given:", givenValue);
            return;
        }

        this._length = Math.max(0, givenValue);
        this.element.style.width = `${this._length}px`;

        this.size.x = this._length;
    }

    set thickness(givenValue) {

        if (typeof givenValue != "number") {
            console.error("LineInstanceThicknessError: invalid length given:", givenValue);
            return;
        }

        this._thickness = Math.max(0, givenValue);
        this.element.style.height = `${this._thickness}px`;

        this.size.y = this._thickness;
    }

    set color(givenValue) {

        if (!(givenValue instanceof Array)) {
            console.error("LineInstanceColorError: invalid color given:", givenValue);
            return;
        }

        const beforeFilter = givenValue.copyWithin();
        givenValue = givenValue.filter(value => typeof value == "number");
        
        if (givenValue.length < 3) {
            console.error("LineInstanceColorError: the given color doesnt has RGB:", givenValue, "\nunfilter given color:", beforeFilter);
            return
        }

        function clamp(value, min, max) {
            return Math.max(Math.min(max, value), min);
        }

        const R = clamp(givenValue[0], 0, 255);
        const G = clamp(givenValue[1], 0, 255);
        const B = clamp(givenValue[2], 0, 255);
        const ALPHA = clamp(givenValue[3], 0, 1);

        this.element.style.backgroundColor = `rgba(${R}, ${G}, ${B}, ${ALPHA || 1})`;
    }

    constructor(length = 300, thickness = 10, color = Instance.COLOR_PURPLE_HUD, position = new Vector(), rotation = 0, anchorPoint = new Vector(0, .5), scale = 1, size = new Vector()) {
        super(position, rotation, anchorPoint, scale, size);

        this.element = document.createElement("div");
        this.element.classList.add("instance", "line");

        this.length = length;
        this.thickness = thickness;
        this.color = color;
    }
}

