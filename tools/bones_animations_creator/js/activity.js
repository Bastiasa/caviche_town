
var bones = [];

const worldContainer = document.querySelector("#world_container");
const world = document.querySelector("#world");

var worldZoom = 1;
var worldAdedPosition = Vector.zero;
var mainLoopFrame = -1;

var isDragging = false;
var draggingSensitivity = 0.5

document.body.addEventListener("mousedown", e => {    
    
    const worldContainerRect = worldContainer.getBoundingClientRect();
    const clickPosition = new Vector(e.clientX, e.clientY)

    const isInX = clickPosition.x >= worldContainerRect.left && clickPosition.x < worldContainerRect.right;
    const isInY = clickPosition.y >= worldContainerRect.top && clickPosition.y < worldContainerRect.bottom;

    if (isInX && isInY && e.button == 1 && e.ctrlKey) {

        if (e.target instanceof HTMLElement && e.target.classList.contains("bone") || e.target.classList.contains("bone_vertex")) {
            return;
        }

        isDragging = true;
    }

});

document.addEventListener("mouseleave", e=>isDragging = false);
document.addEventListener("mouseup", e=>isDragging = false);

document.addEventListener("mousemove", e => {

    if (!isDragging) {
        return;
    }

    const position = new Vector(e.offsetX, e.offsetY);

    const movement = new Vector(e.movementX, e.movementY);
    worldAdedPosition = worldAdedPosition.add(movement.multiply(draggingSensitivity));        
});

var lastWindowSize = new Vector(window.innerWidth, window.innerHeight);

window.addEventListener("resize", e => {
    const currentSize = new Vector(window.innerWidth, window.innerHeight);
    worldAdedPosition = currentSize.multiply(worldAdedPosition.divide(lastWindowSize));
    lastWindowSize = currentSize;
});


worldContainer.addEventListener("wheel", e => {
    if (e.ctrlKey) {
        e.preventDefault();
        worldZoom -= (e.deltaY) / 1000;

        worldZoom = Math.max(worldZoom, 0.01)
    }

});

var currentContextMenu = null;
var currentContextMenuTarget = null;

const contextMenus = [
    document.querySelector("#cm_0").cloneNode(true),
    document.querySelector("#cm_1").cloneNode(true),
    document.querySelector("#cm_2").cloneNode(true),
    document.querySelector("#cm_3").cloneNode(true),
    document.querySelector("#cm_4").cloneNode(true),
];

/**
 * 
 * @param {HTMLElement} targetElement 
 * @returns {HTMLElement?}
 */
function getOnTargetContextMenu(targetElement) {

    let result = -1;

    if (selectedBones.length > 0) {
        result = 4;
    } else if (targetElement == world || targetElement == worldContainer) {
        result = 0;
    } else if (targetElement.classList.contains("bone_vertex") && targetElement.classList.contains("end")) {
        result = 1;
    } else if (targetElement.classList.contains("bone_vertex")) {
        result = 2;
    } else if (targetElement.classList.contains("bone")) {
        result = 3;
    } 

    const menu = contextMenus[result];


    console.log(menu);
    

    if (menu instanceof HTMLElement) {
        currentContextMenuTarget = targetElement;
        return menu.cloneNode(true);
    } else {
        return null;
    }
}

worldContainer.addEventListener("contextmenu", e => {

    if (currentContextMenu instanceof HTMLElement) {
        const cm = currentContextMenu;
        currentContextMenu = null;
        currentContextMenuTarget = null;
        window.setTimeout(() => cm.remove(), 200);
        cm.classList.add("hidden");
    }

    const newContextMenu = getOnTargetContextMenu(e.target);

    if (!newContextMenu) {
        currentContextMenuTarget = null;
        return;
    } else {
        e.preventDefault();
    }

    newContextMenu.id = "";

    newContextMenu.style.top = e.clientY.toString()+"px";
    newContextMenu.style.left = e.clientX.toString() + "px";

    document.body.appendChild(newContextMenu);

    setTimeout(() => {
        newContextMenu.classList.remove("hidden");   
    }, 150);

    currentContextMenu = newContextMenu;

    const cmRight = newContextMenu.offsetWidth + e.clientX;
    const cmBottom = newContextMenu.offsetHeight + e.clientY;
    

    if (cmRight > window.innerWidth) {
        const x = e.clientX - (cmRight - window.innerWidth);
        newContextMenu.style.left = x.toString() + "px";
    }

    if (cmBottom > window.innerHeight) {
        const y = e.clientY - (cmBottom - window.innerHeight);
        newContextMenu.style.top = y.toString()+"px";
    }


    document.addEventListener("click", e => {
        newContextMenu.classList.add("hidden");
        currentContextMenuTarget = null;
        window.setTimeout(()=>newContextMenu.remove(), 200);
    }, { once:true});
});

function resetCanvasTransform() {
    worldAdedPosition = Vector.zero;
    worldZoom = 1;
}


const mainLoop = (time) => {

    const currentPosition = Vector.fromElement(world);
    let newPosition = new Vector(worldAdedPosition.x, worldAdedPosition.y);

    newPosition = currentPosition.add(newPosition.substract(currentPosition).multiply(0.24));

    world.style.left = (newPosition.x || 1).toString() + "px";
    world.style.top = (newPosition.y || 1).toString() + "px";

    const currentScale = parseFloat(world.style.scale);

    if (isFinite(currentScale)) {
        world.style.scale = (currentScale + (worldZoom - currentScale) * 0.24).toString();
    } else {
        world.style.scale = worldZoom.toString();
    }

    mainLoopFrame = requestAnimationFrame(mainLoop);
}

mainLoop();