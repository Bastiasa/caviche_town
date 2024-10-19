const nodesPanel = document.querySelector("#nodes_panel");
const selectionPropertiesPanel = document.querySelector("#selection_properties_panel");
const propertiesPanelTemplates = document.querySelector(".instance_properties_templates");
const propertiesPanel = document.querySelector("#selection_properties_panel");
propertiesPanelTemplates.remove();

var lastSelectedInstanceFromNode = null;

/**@type {?Instance} */
var currentSelectedInstance = null;

function createNodeInPanel(instance) {
    const nodeInPanel = document.createElement("span");

    nodeInPanel.classList.add("node_in_panel", instance.constructor.instanceName.toLowerCase());
    nodeInPanel.innerText = instance.name || "Not named";

    nodeInPanel.addEventListener("click", e => { 

        const viewport = instance.viewport;

        if (viewport instanceof Viewport) {

            if (!e.ctrlKey && !e.shiftKey) {
                viewport.deselectAllInstances();
            }

            viewport.selectOrDeselectInstance(instance);

            if (viewport.isInstanceSelected(instance)) {
                
                if (e.shiftKey && lastSelectedInstanceFromNode instanceof Instance && typeof lastSelectedInstanceFromNode.index == "number") {
                    const lastSelectedIndex = lastSelectedInstanceFromNode.index;
                    const begin = Math.min(lastSelectedIndex, instance.index) + 1;
                    const end = Math.max(lastSelectedIndex, instance.index);
                    const toSelect = Array.from(viewport.instances).slice(begin, end);
                    toSelect.forEach(viewport.selectInstance.bind(viewport));
                }

                lastSelectedInstanceFromNode = instance;
            } else {
                lastSelectedInstanceFromNode = null;
            }
        }
    });

    return nodeInPanel;
}

function getPropertiesPanelTemplate(index) {
    return propertiesPanelTemplates.children[index].cloneNode(true);
}

function setInputDataFromInstance(inputContainer, instance) {
    if (instance instanceof Instance && inputContainer) {
        inputContainer.querySelector("input[name=name]").value = instance.name;
        inputContainer.querySelector("input[name=position_x]").value = instance.position.x.toString();
        inputContainer.querySelector("input[name=position_y]").value = instance.position.y.toString();
        
        inputContainer.querySelector("input[name=anchor_point_x]").value = instance.anchorPoint.x.toString();
        inputContainer.querySelector("input[name=anchor_point_y]").value = instance.anchorPoint.y.toString();

        inputContainer.querySelector("input[name=scale]").value = instance.scale.toString();
        inputContainer.querySelector("input[name=rotation]").value = instance.degreeRotation.toString();
        inputContainer.querySelector("input[name=z_index]").value = instance.zIndex.toString();

        if (instance instanceof LineInstance) {
            inputContainer.querySelector("input[name=color]").value = instance.color;
            inputContainer.querySelector("input[name=length]").value = instance.length.toString();
            inputContainer.querySelector("input[name=thickness]").value = instance.thickness.toString();
        }
    }
}

/**
 * 
 * @param {?Instance} instance 
 */
function startPropertiesPanel(instance) {

    removeAllChildren(propertiesPanel);
    let template;

    if (instance instanceof ImageInstance) {
        template = getPropertiesPanelTemplate(0);
    } else if (instance instanceof LineInstance) {
        template = getPropertiesPanelTemplate(1);
    }

    if (template) {

        setInputDataFromInstance(template, instance);

        /**
         * 
         * @param {?HTMLInputElement} inputElement 
         * @param {(newValue)=>void} action 
         * @param {'number'|'string'|'color'} valType 
         * @param {string} evName 
         */
        function checkAndSet(inputElement, action , valType = "number", evName = "input") {
            if (inputElement instanceof HTMLInputElement) {
                inputElement.addEventListener(evName, e => {
                    
                    let newValue;

                    switch (valType) {
                        case 'number':
                            newValue = parseFloat(inputElement.value);
                            if (isFinite(newValue)) {
                                action(newValue);
                            }
                            break;
                        
                        case 'string':
                            action(inputElement.value);
                            break;
                        
                        case "color":
                            break;
                    
                        default:
                            break;
                    }
                });
            }
        }

        function getInput(name) {
            return template.querySelector(`input[name=${name}]`);
            
        }

        if (instance instanceof Instance) {
            checkAndSet(getInput("name"), val => instance.name = val, "string");

            checkAndSet(getInput("position_x"), val => instance.position.x = val);
            checkAndSet(getInput("position_y"), val => instance.position.y = val);

            checkAndSet(getInput("anchor_point_x"), val => instance.anchorPoint.x = val);
            checkAndSet(getInput("anchor_point_y"), val => instance.anchorPoint.y = val);

            checkAndSet(getInput("rotation"), val => instance.degreeRotation = val);
            checkAndSet(getInput("scale"), val => instance.scale = val);
            checkAndSet(getInput("z_index"), val => instance.zIndex = val);
        }

        if (instance instanceof LineInstance) {
            checkAndSet(getInput("color"), val => instance.color = val, "string");
            checkAndSet(getInput("length"), val => instance.length = val);
            checkAndSet(getInput("thickness"), val => instance.thickness = val);
        }

        Array.from(template.children).forEach(child => {
            propertiesPanel.appendChild(child);
        });

        propertiesPanel.classList.remove("disabled");
    } else {
        propertiesPanel.classList.add("disabled");
    }
}

viewport.onInstanceAdded.addListener(
    
    /**
     * @param {Instance} addedInstance 
     * @param {number} instanceIndex
     */
    (addedInstance, instanceIndex) => {
        addedInstance.nodeInPanel = createNodeInPanel(addedInstance);
        nodesPanel.appendChild(addedInstance.nodeInPanel);
        addedInstance.onPropertyChanged.addListener(() => {
            
            if (currentSelectedInstance === addedInstance) {
                setInputDataFromInstance(propertiesPanel, addedInstance);
            }

            addedInstance.nodeInPanel.innerText = addedInstance.name;
        });
    }

);

viewport.onInstanceRemoved.addListener(
    
    /**
     * @param {Instance} addedInstance 
     */
    removedInstance => {

        if (removedInstance.nodeInPanel instanceof HTMLElement) {
            removedInstance.nodeInPanel.remove();
            removedInstance.nodeInPanel = undefined;
        }
    }

);

viewport.onInstaceSelected.addListener(
    
    /**
     * 
     * @param {Instance} selectedInstance 
     * @param {number} selectionIndex 
     */
    (selectedInstance, selectionIndex) => {

        currentSelectedInstance = selectedInstance;
        startPropertiesPanel(currentSelectedInstance);

        if (selectedInstance.nodeInPanel instanceof HTMLElement) {
            selectedInstance.nodeInPanel.classList.add("selected");
        }
        
    }
)

viewport.onInstaceDeselected.addListener(
    
    /**
     * 
     * @param {Instance} selectedInstance 
     */
    deselectedInstance => {

        if (deselectedInstance == currentSelectedInstance) {
            currentSelectedInstance = null;
            startPropertiesPanel(null);
        }

        if (deselectedInstance.nodeInPanel instanceof HTMLElement) {
            deselectedInstance.nodeInPanel.classList.remove("selected");
        }
        
    }
)


