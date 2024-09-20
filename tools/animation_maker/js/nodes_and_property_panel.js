const nodesPanel = document.querySelector("#nodes_panel");
const selectionPropertiesPanel = document.querySelector("#selection_properties_panel");

var lastSelectedInstanceFromNode = null;

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

viewport.onInstanceAdded.addListener(
    
    /**
     * @param {Instance} addedInstance 
     * @param {number} instanceIndex
     */
    (addedInstance, instanceIndex) => {
        addedInstance.nodeInPanel = createNodeInPanel(addedInstance);
        nodesPanel.appendChild(addedInstance.nodeInPanel);
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
    selectedInstance => {

        if (selectedInstance.nodeInPanel instanceof HTMLElement) {
            selectedInstance.nodeInPanel.classList.remove("selected");
        }
        
    }
)


