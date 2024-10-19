
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

function inside(a, b, offset = 5) {
    return a > b - offset && a < b + offset
}

function rgbaToHex(r, g, b, a = 1) {
    // Convertir los valores RGB a hexadecimal y asegurarse de que tengan dos dígitos
    const hexR = r.toString(16).padStart(2, '0');
    const hexG = g.toString(16).padStart(2, '0');
    const hexB = b.toString(16).padStart(2, '0');

    // Convertir el valor alfa (0-1) a hexadecimal de dos dígitos
    const hexA = Math.round(a * 255).toString(16).padStart(2, '0');

    // Retornar el código hexadecimal completo
    return `#${hexR}${hexG}${hexB}${a < 1 ? hexA : ''}`; // Solo agregar alfa si es menor a 1
}
