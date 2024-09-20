
/**@type {Vector?} */
var lastMousePosition = null;
var isMouseOnPage = true;
var isMouseDown = false;

document.addEventListener("mousedown", e => isMouseDown = true);
document.addEventListener("mouseup", e => isMouseDown = false);

document.addEventListener("mouseenter", e => isMouseOnPage = true);
document.addEventListener("mouseleave", e => isMouseOnPage = false);

document.addEventListener("mousemove", e => lastMousePosition = new Vector(e.clientX, e.clientY));

const viewportContainer = document.querySelector("#viewport_container");
const viewport = new Viewport(document.querySelector("#viewport"));

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
 * @param {HTMLElement} element 
 * @param {Vector} newPosition 
 */
function setElementSize(element, size) {
    element.style.width = size.x.toString() + "px";
    element.style.height = size.y.toString() + "px";
}

