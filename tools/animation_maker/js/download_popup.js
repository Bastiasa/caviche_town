const downloadPopup = document.querySelector("#download_popup")
const downloadPopupWhitelist = document.querySelector("#animation_export_whitelist");
const cancelButton = document.querySelector("#cancel_download_button");

const downloadAnimationsButton = document.querySelector("#download_animations_button");

downloadPopup.addEventListener("submit", e => {
    e.preventDefault();

    const animationOptions = new FormData(downloadPopup);
    

    /**@type {AnimationPackageOptions} */
    const options = {
        keepImagesContent: animationOptions.get("keep_images_content") === "on",
        onlyAnimatedInstances: animationOptions.get("only_animated") === "on",
        animationsWhitelist:[]
    };

    animationOptions.forEach((value, key) => {
        if (key.startsWith("animation:")) {
            options.animationsWhitelist.push(key.split("animation:", 2)[1]);
        } 
    });
    
    const fileName = prompt("Escriba el nombre del proyecto", "Sin nombre");
    const result = generateAnimationsPackage(options);

    const rawData = new Blob([JSON.stringify(result)], { type: "application/json" });
    const a = document.createElement("a");

    a.href = URL.createObjectURL(rawData);
    a.download = `${fileName || "Sin nombre"}.json`;

    document.body.appendChild(a);
    a.click();
    a.remove();

    downloadPopup.parentElement.classList.add("hidden");
});

downloadAnimationsButton.addEventListener("click", e => {

    if (animations.size < 1) {
        return;
    }

    instanceAnimationsInWhitelist();
    downloadPopup.parentElement.classList.remove("hidden");
});

cancelButton.addEventListener("click", e => {
    downloadPopup.parentElement.classList.add("hidden");
})

function instanceAnimationsInWhitelist() {
    removeAllChildren(downloadPopupWhitelist);

    animations.forEach(animation => {
        const elemnt = document.createElement("div");
        const animationName = document.createElement("span");
        const checkbox = document.createElement("input");
        const checkboxContainer = document.createElement("span");

        animationName.style.flexGrow = "1";
        animationName.style.textAlign = "center";

        checkbox.type = "checkbox";
        checkbox.checked = true;
        checkbox.name = `animation:${animation.name}`;
        animationName.textContent = animation.name;


        elemnt.classList.add("whitelist_animation_container", "joined_elements_container");

        checkboxContainer.appendChild(checkbox);
        elemnt.appendChild(checkboxContainer);
        elemnt.appendChild(animationName);

        downloadPopupWhitelist.appendChild(elemnt);
    })
}

/**
 * 
 * @typedef AnimationPackageOptions 
 * @property {boolean} keepImagesContent
 * @property {boolean} onlyAnimatedInstances
 * @property {Array<string>} animationsWhitelist
 */

/**
 * 
 * @param {AnimationPackageOptions} options 
 * @returns 
 */
function generateAnimationsPackage(options) {
    
    let result = {
        "animations": [],
        "instances":[]
    }

    const animatedInstances = new Set();
    
    animations.forEach(animation => {

        if (!options.animationsWhitelist.includes(animation.name)) {
            return;
        }

        const animationData = {
            "name": animation.name,
            "fps": animation.fps,
            "frames": animation.totalFrames,
            "loop":animation.loop,
            "keyframes": []
        };

        animation.getSortedKeyframes().forEach(keyframe => {
            const keyframeData = {
                "properties": [],
                "frame":keyframe.frame
            }

            keyframe.properties.forEach(property => {
                keyframeData.properties.push({
                    "instance_name": property.instance.name,
                    "position": property.position.toObject(),
                    "anchor_point": property.anchorPoint.toObject(),
                    "scale": property.scale,
                    "rotation": property.rotation
                });

                if (options.onlyAnimatedInstances) {
                    animatedInstances.add(property.instance);
                }

            });

            animationData.keyframes.push(keyframeData);
        });

        result.animations.push(animationData);
    });

    viewport.instances.forEach(instance => {

        if (options.onlyAnimatedInstances && !animatedInstances.has(instance)) {
            return;
        }

        const instanceData = {
            "name": instance.name,
            "type": instance.constructor.instanceName
        };

        if (instance instanceof ImageInstance) {
            if (options.keepImagesContent) {
                instanceData["image_content"] = instance.src;
            }
        } else if (instance instanceof LineInstance) {
            instanceData["length"] = instance.length;
            instanceData["thickness"] = instance.thickness;
        }

        result.instances.push(instanceData);
    });

    return result;
}
