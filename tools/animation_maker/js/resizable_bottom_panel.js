const bottomPanel = document.querySelector("#bottom_panel");

bottomPanel.style.height = localStorage.getItem("bottomPanelHeight") || "25%";

var isResizingBottomPanel = false;

document.addEventListener("mouseup", e => isResizingBottomPanel = false);
document.addEventListener("mousedown", e => {
    
    const mousePosition = new Vector(e.clientX, e.clientY);
    const bottomPanelRect = bottomPanel.getBoundingClientRect();

    isResizingBottomPanel = (mousePosition.y < bottomPanelRect.top + 8 && mousePosition.y > bottomPanelRect.top - 8) 
});

document.addEventListener("mousemove", e => {
    const bottomPanelRect = bottomPanel.getBoundingClientRect();

    if (isResizingBottomPanel) {
        bottomPanel.style.height = (bottomPanel.offsetHeight + (bottomPanelRect.top - lastMousePosition.y)).toString() + "px";
        localStorage.setItem("bottomPanelHeight", bottomPanel.style.height);

        document.body.style.cursor = "row-resize";
        return;
    } else {
        if (document.body.style.cursor == "row-resize") {
            document.body.style.cursor = "unset";        
        }
    }


    if (lastMousePosition instanceof Vector && (lastMousePosition.y < bottomPanelRect.top + 8 && lastMousePosition.y > bottomPanelRect.top - 8)) {
        document.body.style.cursor = "row-resize";
        

    } else {
        if (document.body.style.cursor == "row-resize") {
            document.body.style.cursor = "unset";        
        }
    }

});