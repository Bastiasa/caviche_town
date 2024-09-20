

var creatingBoneParent = null;
var creatingBoneElement = null;
var isCreatingBone = false;

var lastMousePosition = Vector.zero;
var lastMousePositionLocked = null;

var toRedoActions = [];
var toUndoActions = [];
var selectedBones = [];

document.addEventListener("mousemove", e => {

    const offsetPosition = new Vector(e.offsetX, e.offsetY);

    if (e.target == world) {
        lastMousePosition = offsetPosition;
        
    } else if (e.target == worldContainer) {
        const amount = worldAdedPosition.add(Vector.getOffsetSize(world).multiply(.5).multiply(1-worldZoom))
        lastMousePosition = new Vector(e.offsetX, e.offsetY);
        lastMousePosition = lastMousePosition.substract(amount);
    }

    if (e.shiftKey && isCreatingBone) {

        const startPosition = getBoneElementPosition(creatingBoneElement);
        const angleVector = lastMousePosition.substract(startPosition);
        const angle = angleVector.angle;

        if (angle < 45 && angle > -45 || angle < -135 || angle > 135) {
            lastMousePosition.y = startPosition.y;
        } else if (angle > 45 && angle < 45 + 90 || angle < -45 && angle > -45 - 90) {
            lastMousePosition.x = startPosition.x;
        }
        
    } else {
        lastMousePositionLocked = lastMousePosition;
    }
});

document.addEventListener("click", e => {
    if (e.target == world || e.target == worldContainer) {
        if (isCreatingBone) {
            finishBoneCreation();
        }
    }

    if (e.target.classList.contains("bone")) {

        
        if(!e.shiftKey) {
            selectedBones.forEach(selectedBone => selectedBone.classList.remove("selected"));
            selectedBones = [];
        }

        selectOrDeselectBoneElement(e.target);
    } else if (!e.shiftKey) {
        selectedBones.forEach(selectedBone => selectedBone.classList.remove("selected"))
        selectedBones = [];
    }
});

function selectOrDeselectBoneElement(boneElement) {
    if(boneElement.classList.contains("selected")) {
        boneElement.classList.remove("selected");
        selectedBones = selectedBones.filter(sb => sb !== boneElement);
    } else {
        boneElement.classList.add("selected");
        selectedBones.push(boneElement);
    }
}

function deleteSelectedBones() {
    selectedBones.forEach(deleteBoneByElement);
}

function selectAllBones() {
    selectedBones.forEach(selectOrDeselectBoneElement);
    selectedBones = Array.from(world.querySelectorAll(".bone"));
    selectedBones.forEach(boneElement=>boneElement.classList.add("selected"));
    console.log("All bones selected.");
    
}


function redo() {
    toRedoActions.pop().redo();
}

function undo() {
    toUndoActions.pop().undo();
}

function addRedoAction(name, redo) {
    toUndoActions.push({
        "name": name,
        undo: redo
    });
}

function addUndoAction(name, undo) {
    toUndoActions.push({
        "name": name,
        undo: undo
    });
}

function createBoneElement(position = Vector.zero, placeholder = false) {
    const boneElement = document.createElement("div");
    const boneVertex = document.createElement("div");
    const boneEndVertex = document.createElement("div");

    boneElement.classList.add("bone");
    boneVertex.classList.add("bone_vertex");
    boneEndVertex.classList.add("bone_vertex", "end");


    if (placeholder) {
        boneElement.classList.add("placeholder");
    }

    boneElement.appendChild(boneVertex);
    boneElement.appendChild(boneEndVertex);

    world.appendChild(boneElement);
    setBoneElementPosition(boneElement, position);
    
    return boneElement;
}

function getBoneVertexElement(boneElement) {
    return boneElement.querySelector(".bone_vertex");
}

function instanceDotAt(position) {
    const elem = document.createElement("div");
    elem.classList.add("dot");
    setElementPosition(elem, position);

    world.appendChild(elem);
}

function getBoneElementPosition(boneElement) {
    let result = new Vector(boneElement.offsetLeft, boneElement.offsetTop);
    const boneVertex = boneElement.querySelector(".bone_vertex");
    
    if (!boneVertex) {
        return Vector.zero;
    }

    let boneVertexSize = Vector.getOffsetSize(boneVertex);
    let boneS = Vector.getOffsetSize(boneElement);

    result.x -= boneVertexSize.x * .5;
    result.y += boneS.y * .5;

    return result;
}

function getVertexSize() {
    const vetexElement = document.createElement("div");
    vetexElement.classList.add("bone_vertex");
    world.appendChild(vetexElement);

    const result = Vector.getOffsetSize(vetexElement);
    vetexElement.remove();
    return result;
}

function getBoneHeight() {
    const boneElement = document.createElement("div");
    boneElement.classList.add("bone");
    world.appendChild(boneElement);

    const result = Vector.getOffsetSize(boneElement);
    boneElement.remove();
    return result.y;
}

function cancelBoneCreation() {

    if (!isCreatingBone) {
        return;
    }

    isCreatingBone = false;
    creatingBoneParent = null;
    destroyBoneElement(creatingBoneElement);
    creatingBoneElement = null;
}

function startBoneCreation(parent = null) {
    cancelBoneCreation();

    let position = lastMousePosition;

    if (parent == null && bones.length > 0) {
        position = bones[0].position;
    } else if (parent instanceof Bone) {
        position = parent.endPosition;
    } else if (parent instanceof HTMLElement && parent.classList.contains("bone")) {
        const boneId = parseFloat(parent.getAttribute("data-id"));
        const bone = getBoneById(boneId);

        if (!boneId && !(bone instanceof Bone)) {
            return;
        }

        position = bone.endPosition;
        parent = bone;
    }

    isCreatingBone = true;
    creatingBoneParent = parent;
    creatingBoneElement = createBoneElement(position, true);
    
}

function finishBoneCreation() {

    if (!isCreatingBone) {
        return;
    }

    const createdBoneElement = creatingBoneElement;
    const createdBoneParent = creatingBoneParent;

    creatingBoneParent = null;
    creatingBoneElement = null;
    isCreatingBone = false;

    const createdBone = new Bone(getBoneElementPosition(createdBoneElement), parseFloat(createdBoneElement.style.rotate), createdBoneElement.offsetWidth+getVertexSize().x, createdBoneParent);
    createdBone.id = performance.now();

    console.log(createdBoneElement.offsetWidth, createdBone.length);
    console.log(createdBoneElement.style.rotate, createdBone.angle);
    console.log(getBoneElementPosition(createdBoneElement).toString(), createdBone.position.toString());
    console.log(lastMousePosition.toString(), createdBone.endPosition.toString());

    createdBoneElement.classList.remove("placeholder");
    createdBoneElement.setAttribute("data-id", createdBone.id.toString());



    if (createdBoneParent instanceof Bone) {
        createdBoneParent.appendChild(createdBone);
    } else {
        bones.push(createdBone);
    }

    const addingRedoActions = ()=> addUndoAction("Bone created", () => {
        
        const oldBoneParent = createdBone.parent;
        deleteBoneById(createdBone.id);
    });

    addingRedoActions();

    return createdBone;
}

function getBoneById(boneId) {

    let result = null;

    function lookInChildren(children) {
        for (let index = 0; index < children.length; index++) {
            const bone = children[index];
            
            if (bone.id == boneId) {
                result = bone;
                break;
            }

            if (bone.children.length > 0) {
                lookInChildren(bone.children);
            }
        }
    }

    lookInChildren(bones);
    return result;
}

function destroyBoneElement(boneElement) {
    boneElement.classList.add("hidden");
    setTimeout(() => {
        boneElement.remove();
    }, 200);
}

function deleteBoneById(boneId) {

    if (!isFinite(boneId)) {
        return;
    }

    /**@type {Bone?}*/
    const bone = getBoneById(boneId);

    if (!(bone instanceof Bone)) {
        return;
    }


    if (bone.parent != null) {
        bone.parent.removeChild(bone);
    } else {
        bones = bones.filter(b => b !== bone);
    }

    bone.destroy();
}

function deleteBoneByElement(boneElement) {
    if (!(boneElement instanceof HTMLElement)) {
        return;
    }

    destroyBoneElement(boneElement);
    const boneId = parseFloat(boneElement.getAttribute("data-id"));

    if (!isFinite(boneId)) {
        return;
    }

    
    deleteBoneById(boneId);
}

function deleteBoneByVertex(vertex) {
    const boneElement = vertex.parentElement;

    if (!boneElement) {
        return;
    }

    deleteBoneByElement(boneElement);
}

function getBoneElementByVertex(vertex) {
    const boneElement = vertex.parentElement;

    if (!boneElement.classList.contains("bone") || !(boneElement instanceof HTMLElement)) {
        return null;
    }

    return boneElement;
}

function getBoneByVertex(vertex) {
    if (!vertex) {
        return;
    }

    const boneElement = getBoneElementByVertex(vertex);
    const boneId = parseFloat(boneElement.getAttribute("data-id"));
    const bone = getBoneById(boneId);

    if (!boneId && !(bone instanceof Bone)) {
        return;
    }

    return bone;
}

function appendChildBone(parentBone) {
    const newBoneInfo = createBone(false);
    parentBone.appendChild(newBoneInfo.bone);
    world.appendChild(newBoneInfo.boneElement);
}

/**
 * 
 * @param {HTMLElement} element 
 * @param {Vector} newPosition 
 */
function setElementPosition(element, newPosition) {
    element.style.left = newPosition.x.toString() + "px";
    element.style.top = newPosition.y.toString() + "px";
}

/**
 * 
 * @param {Vector} position 
 * @param {HTMLElement} element 
 */
function isInsideOf(position, element) {
    const rect = element.getBoundingClientRect();

    const isInX = position.x >= rect.left && position.x <= rect.right;
    const isInY = position.y >= rect.top && position.y <= rect.bottom;

    return isInX && isInY;
}


function setBoneElementPosition(boneElement, newPosition) {
    /**@type {Vector} */
    let result = newPosition.copy();
    const boneVertex = boneElement.querySelector(".bone_vertex");
    
    if (!boneVertex) {
        return;
    }

    let boneVertexSize = Vector.getOffsetSize(boneVertex);
    let boneS = Vector.getOffsetSize(boneElement);

    result.x += boneVertexSize.x * .5;
    result.y -= boneS.y * .5;
    
    setElementPosition(boneElement, result);
}

function setBoneElementEndPosition(boneElement, newPosition) {
    let result = newPosition.copy();
    let boneSize = Vector.getOffsetSize(boneElement);
    const boneVertex = boneElement.querySelector(".bone_vertex");
    
    if (!boneVertex) {
        return;
    }

    let boneVertexSize = Vector.getOffsetSize(boneVertex);
    let bonePosition = Vector.fromElement(boneElement);

    bonePosition.x -= boneVertexSize.x * .5;
    bonePosition.y += boneSize.y * .5;

    let angleVector = newPosition.substract(bonePosition);

    const boneVertexSizeNormalized = boneVertexSize.multiply(angleVector.normalized);
    angleVector = angleVector.substract(boneVertexSizeNormalized);

    boneElement.style.rotate = `${angleVector.angle}deg`;
    boneElement.style.width = `${angleVector.magnitude}px`;
}

let worldMainLoopFrame = -1;

const worldMainLoop = (time) => {

    if (isCreatingBone && creatingBoneElement instanceof HTMLElement) {
        setBoneElementEndPosition(creatingBoneElement, lastMousePosition);
    }

    world.querySelectorAll(".bone:not(.placeholder)").forEach(boneElement => {

        if (boneElement.classList.contains("placeholder")) {
            return;
        }

        const boneId = parseFloat(boneElement.getAttribute("data-id"));
        
        if (!boneId) {
            destroyBoneElement(boneElement);
            return
        }

        /**@type {Bone?} */
        const bone = getBoneById(boneId);

        if (!(bone instanceof Bone)) {
            destroyBoneElement(boneElement);
            return;
        }

        setBoneElementPosition(boneElement, bone.position);
        setBoneElementEndPosition(boneElement, bone.endPosition);
    });

    worldMainLoopFrame = requestAnimationFrame(worldMainLoop);
}

worldMainLoop();

window.addEventListener("keyup", e => {
    if (e.key == "e") {
        startBoneCreation(finishBoneCreation());
    }

    if (e.key == "r") {
        instanceDotAt(lastMousePosition);
    }

    if (e.key == "Escape") {
        cancelBoneCreation();
    }

    if (e.key == "z" && e.ctrlKey) {
        undo();
    } else if (e.key == "z" && e.ctrlKey && e.shiftKey) {
        redo();
    }
});