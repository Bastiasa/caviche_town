
viewport.scale = 0.3

const contextMenuTemplates = [
    document.querySelector("#cm_0").cloneNode(true),
    document.querySelector("#cm_1").cloneNode(true),
    document.querySelector("#cm_2").cloneNode(true),
];

function setDisabled(contextMenuButton, disabled = true) {
    if (!contextMenuButton) {
        return;
    }

    if (disabled) {
        contextMenuButton.classList.add("disabled");
    } else {
        contextMenuButton.classList.remove("disabled");
    }
}

function checkContextMenuParameter(contextMenu, buttonClass, parameter = true) {
    const foundButton = contextMenu.querySelector("."+buttonClass);
    
    if (foundButton) {
        setDisabled(foundButton, !parameter);
    }
}

/**
 * @type {Array<{"templateId":number, "setUp":(template:HTMLElement)=>void}>}
 */
const contextMenuTemplatesSetUp = [
    {
        templateId: 0,
        setUp: template => {

            checkContextMenuParameter(template, "select_all", viewport.instances.size > 0);
            checkContextMenuParameter(template, "go_to_center", viewport.position.area() !== 0);
        }
    },

    {
        templateId: 1,
        setUp: template => {

            /**@type {Instance} */
            const target = contextMenu.targetInstance;

            
            if (!target) {
                return;
            }

            checkContextMenuParameter(template, "go_to_center", viewport.position.area() !== 0);
            checkContextMenuParameter(template, "send_to_viewport_center", target.position.area() !== 0);
            checkContextMenuParameter(template, "send_to_screen_center", target.position.area() !== viewport.position.negative.area());
            checkContextMenuParameter(template, "reset_rotation", target.rotation !== 0);
            checkContextMenuParameter(template, "reset_scale", target.scale !== 1);
        }
    }
]

contextMenuTemplates.forEach(contextMenuTemplate => contextMenuTemplate.remove());

/**@type {HTMLElement?} */
var lastContextMenuTarget = null;

/**@type {HTMLElement?} */
var lastContextMenu = null;


/**
 * 
 * @param {HTMLElement} targetElement 
 * @returns {HTMLElement?}
 */
function getCurrentContextMenu(targetElement) {

    if (!(targetElement instanceof HTMLElement)) {
        lastContextMenu = null;
        lastContextMenuTarget = null;
        return null;
    }

    lastContextMenuTarget = targetElement;

    let contextMenuIndex = -1;

    const rect = targetElement.getBoundingClientRect();

    if (!viewport.action) {
        if ((targetElement === viewportContainer || targetElement == viewport.element || targetElement === nodesPanel) && viewport.selectedInstances.size < 1) {
            contextMenuIndex = 0;
        } else if (viewport.selectedInstances.size > 1) {
            contextMenuIndex = 2;
        } else if (targetElement.classList.contains("node_in_panel") || targetElement.classList.contains("instance") || viewport.selectedInstances.size === 1) {
            contextMenuIndex = 1;

            if (viewport.selectedInstances.size === 1) {
                lastContextMenuTarget = viewport.getSelectedInstance(0).element;
            } else if (targetElement.classList.contains("node_in_panel")) {
                lastContextMenuTarget = null;

                Array.from(viewport.instances).forEach(instance => {
                    if (lastContextMenuTarget) {
                        return;
                    }

                    if (instance.nodeInPanel == targetElement) {
                        lastContextMenuTarget = instance.element;
                    }
                })

                if (!lastContextMenuTarget) {
                    contextMenuIndex = -1;
                }
            }
        }
    } else {
        return -1
    }


    const result = contextMenuTemplates[contextMenuIndex];

    if (result instanceof HTMLElement) {
        const contextMenu = result.cloneNode(true);
        lastContextMenu = contextMenu;

        const currentSetups = contextMenuTemplatesSetUp.filter(setup => {
            return setup.templateId == contextMenuIndex;
        });

        currentSetups.forEach(setup => setup.setUp(contextMenu));
        return contextMenu;
    } 

    lastContextMenu = null;
    return null
}

function removeContextMenu(contextMenu) {
    contextMenu.classList.add("hidden");
    setTimeout(() => contextMenu.remove(), 200);
}


document.addEventListener("contextmenu", e => {

    if (lastContextMenu instanceof HTMLElement) {
        removeContextMenu(lastContextMenu);
    }
    
    const contextMenu = getCurrentContextMenu(e.target);

    if (contextMenu instanceof HTMLElement) {
        e.preventDefault();

        setElementPosition(contextMenu, lastMousePosition);
        document.body.appendChild(contextMenu);

        viewport.deselectOnClick = false;

        const contextMenuRect = contextMenu.getBoundingClientRect();

        if (contextMenuRect.right > innerWidth) {
            setElementPosition(contextMenu, lastMousePosition.add(Vector.onlyX(innerWidth - contextMenuRect.right)));
        }

        if (contextMenuRect.bottom > innerHeight) {
            setElementPosition(contextMenu, lastMousePosition.add(Vector.onlyY(innerHeight - contextMenuRect.bottom)));
        }

        setTimeout(() => contextMenu.classList.remove("hidden"), 50);
    } else if (contextMenu === -1) {
        e.preventDefault();
    }

});

document.addEventListener("click", e => {
    const clientPosition = new Vector(e.clientX, e.clientY);

    if (lastContextMenu instanceof HTMLElement) {

        if (e.target !== lastContextMenu) {
            removeContextMenu(lastContextMenu);
            viewport.deselectOnClick = true;
        }

    }
});



viewport.appendInstance(new LineInstance(30));