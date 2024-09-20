
class ContextMenuActions {

    constructor() {
        document.addEventListener("contextmenu", e => {
            if (e.target.classList.contains("instance")) {
                this.targetInstance = viewport.getInstanceByElement(e.target); 
            } else if (e.target.classList.contains("node_in_panel")) {
                Array.from(viewport.instances).forEach(instance => {
                    if (this.targetInstance) {
                        return;
                    }

                    if (instance.nodeInPanel === e.target) {
                        this.targetInstance = instance;
                    }
                })
            } else if (viewport.selectedInstances.size <= 1) {
                this.targetInstance = viewport.getSelectedInstance(0);
            } else {
                this.targetInstance = null;
            }
        });
    }

    createImageFromUpload() {
        const tmpInputElement = document.createElement("input");

        tmpInputElement.type = "file";
        tmpInputElement.accept = "image/*";
        tmpInputElement.multiple = true;
        tmpInputElement.style.display = "none";

        var lastImageInstance = null;

        tmpInputElement.addEventListener("change", async e => {

            if (tmpInputElement.files.length < 1) {
                return;
            }

            const files = tmpInputElement.files;

            for (const file of files) {
                const data = await file.arrayBuffer();
                const blob = new Blob([data], { type: file.type });

                const reader = new FileReader();

                reader.onloadend = e => {
                    const imageInstance = new ImageInstance(reader.result, viewport.position.negative);

                    if (lastImageInstance instanceof ImageInstance) {
                        const myLastImageInstance = lastImageInstance;
                        
                        imageInstance.onImageLoadedListeners.push(event => {
                            imageInstance.position.x = myLastImageInstance.position.x + myLastImageInstance.size.x * .5 + imageInstance.size.x * .5                    
                            console.log(imageInstance.size);
                        });
                    }

                    viewport.appendInstance(imageInstance);
                    lastImageInstance = imageInstance;
                }

                reader.readAsDataURL(blob);
            }
            
        });

        document.body.appendChild(tmpInputElement);

        tmpInputElement.click();

    }

    goToCenter() {
        viewport.position = Vector.zero;
    }

    startPositionSetAction = () => {

        if (this.targetInstance && !viewport.isInstanceSelected(this.targetInstance)) {
            viewport.selectInstance(this.targetInstance);
            
        } else if (!this.targetInstance && viewport.selectedInstances.size < 1) {
            return;
        }

        viewport.defaultActions.setSelectedInstancesPosition();  
    }
    startRotationSetAction = viewport.defaultActions.setLastSelectedInstanceRotation;
    startScaleSetAction = viewport.defaultActions.setSelectedInstancesScale;

    createLine() {
        const createdLine = new LineInstance(3, 10, Instance.COLOR_PURPLE_HUD, viewport.mousePosition);
        viewport.appendInstance(createdLine);

        if (!viewport.isMouseInViewport()) {
            createdLine.position = viewport.position.negative;
        }

        viewport.startAction({
            type: Viewport.ACTION_CREATE_LINE,
            line: createdLine,
            finishOnClick: true,
            finishClickInside:true,
            onCancelled: () => viewport.removeInstance(createdLine)
        });
    }

    viewportSelectAll() {
        Array.from(viewport.instances).forEach(instance => {
            viewport.selectInstance(instance);
        });
    }

    deleteFromContextMenu() {
        if (lastContextMenuTarget != null) {

            if (!this.targetInstance) {
                Array.from(viewport.selectedInstances).forEach(viewport.removeInstance.bind(viewport));
                return;
            }

            this.targetInstance.removeFromViewport();
        } else {
            Array.from(viewport.selectedInstances).forEach(viewport.removeInstance.bind(viewport));
        }
    }

    resetScale() {
        Array.from(viewport.selectedInstances).forEach(instance => {
            instance.scale = 1;
        });

        if (this.targetInstance) {
            this.targetInstance.scale = 1;
        }
    }

    resetRotation() {
        Array.from(viewport.selectedInstances).forEach(instance => {
            instance.rotation = 0;
        });

        if (this.targetInstance) {
            this.targetInstance.rotation = 0;
        }
    }

    sendToScreenCenter() {
        if (this.targetInstance) {
            this.targetInstance.position = viewport.position.negative
        }
    }

    sendToViewportCenter() {
        if (this.targetInstance) {
            this.targetInstance.position = Vector.zero;
        }
    }

}

contextMenu = new ContextMenuActions();

document.addEventListener("keyup", e => {
    const key = e.key.toLowerCase();

    if (key == "a" && e.ctrlKey) {
        contextMenu.viewportSelectAll();
    }


    if (key == "1") {
        contextMenu.createLine();
    }

    if (key == "2") {
        contextMenu.createImageFromUpload();
    }

    
});


