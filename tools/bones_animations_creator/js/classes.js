
class Vector {

    /**
     * @param {number} x
     * @param {number} y
     */

    x;
    y;

    constructor(x = 0, y = 0) {
        this.x = x;
        this.y = y;

        if (!x) {
            this.x = 0;
        }

        if (!y) {
            this.y = 0;
        }
    }

    /**
     * 
     * @returns {Vector}
     */
    copy() {
        return new Vector(this.x, this.y);
    }

    /**
     * @param {Vector} other 
     * @returns {Vector}
     */
    add(other) {
        return new Vector(this.x + other.x, this.y + other.y);
    }

    /**
     * 
     * @param {Vector} other 
     * @returns {Vector}
     */
    substract(other) {
        return this.add(other.negative);
    }

    /**
     * @param {Vector|number} other 
     * @returns {Vector}
     */
    multiply(other) {

        if (typeof other == "number") {
            return this.multiply(Vector.diagonalVector(other));
        } else if (other instanceof Vector) {
            return new Vector(this.x * other.x, this.y * other.y);
        }
    }

    /**
     * @param {Vector|number} other 
     * @returns {Vector}
     */
    divide(other) {
        if (typeof other == "number") {
            return this.multiply(Vector.diagonalVector(1 / other));
        } else {
            return this.multiply(new Vector(1 / other.x, 1 / other.y));
        }
    }

    get negative() {
        return new Vector(-this.x, -this.y);
    }

    get magnitude() {
        return Math.sqrt(this.x ** 2 + this.y ** 2);
    }

    set magnitude(newMagnitude) {
        this.x = Math.cos(this.angle) * newMagnitude;
        this.y = Math.sin(this.angle) * newMagnitude;
    }

    get angle() {
        return Math.atan2(this.y, this.x) * (180 / Math.PI);
    }

    set angle(newAngle) {
        this.localAngle = (newAngle / 180)*Math.PI;
        this.x = Math.cos(this.localAngle) * this.magnitude;
        this.y = Math.sin(this.localAngle) * this.magnitude;
    }
    
    get normalized() {
        return this.divide(this.magnitude);
    }

    toString() {
        return `(${this.x}, ${this.y})`;
    }

    static get zero() { return new Vector(0, 0) };
    static get up() { return new Vector(0, 1) };
    static get down() { return new Vector(0, -1) };
    static get left() { return new Vector(-1, 0) };
    static get right() { return new Vector(1, 0) };
    static get topLeft() { return new Vector(-1, 1) };
    static get topRight() { return new Vector(1, 1) };
    static get bottomLeft() { return new Vector(-1, -1) };
    static get bottomRight() { return new Vector(1, -1) };


    /**
     * 
     * @param {HTMLElement} element 
     * @returns {Vector}
     */
    static fromElement(element) {
        return new Vector(element.offsetLeft, element.offsetTop);
    }

    /**
     * 
     * @param {number} magnitude 
     * @param {number} angle 
     * @returns {Vector}
     */
    static fromMagnitudeAndAngle(magnitude, angle, mode = "DEG") {

        if (mode == "DEG") {
            angle = angle / 180 * Math.PI;
        }

        const x = Math.cos(angle) * magnitude;
        const y = Math.sin(angle) * magnitude;
        return new Vector(x, y);
    }

    /**
     * 
     * @param {number} length 
     * @returns {Vector}
     */
    static diagonalVector(length) {
        return new Vector(length, length);
    }
    
    /**
     * 
     * @param {HTMLElement} element 
     * @returns 
     */
    static getOffsetSize(element) {
        return new Vector(element.offsetWidth, element.offsetHeight);
    }
}


class Bone {

    /**
     * @param {Array<Vector>} children
     * @param {Vector} localPosition
     * @param {Vector} position
     * @param {number} angle
     * @param {number} angle
     * @param {Bone?} parent
     * @param {Vector} endPosition
     */

    children;
    localPosition;
    localAngle;
    length;
    parent;

    constructor(position = Vector.zero, angle = 0, length = 1, parent) {

        if (parent instanceof Bone) {
            parent.appendChild(this);
        }

        this.children = [];
        this.length = length;
        this.localPosition = position;
        this.angle = angle;
    }

    destroy() {
        this.children.forEach(child => child.destroy());
        
        if (typeof this.onDestroyed == "function") {
            this.onDestroyed();
        }
    }

    removeChild(child) {

        if (child.parent !== this) {
            return;
        }

        child.parent = null;
        this.children = this.children.filter(c => c !== child);
    }

    appendChild(child) {

        if (!child instanceof Bone) {
            return;
        }

        if (child.parent instanceof Bone) {
            child.parent.removeChild(child);
        }

        this.children.push(child);
        child.parent = this;
    }

    get angle() {

        if (this.parent instanceof Bone) {
            return this.parent.angle + this.localAngle;
        }

        return this.localAngle;
    }

    get position() {
        if (this.parent instanceof Bone) {
            return this.parent.endPosition;
        }

        return this.localPosition;
    }

    set position(newValue) {
        this.localPosition = newValue;
    }

    set angle(newValue) {
        this.localAngle = newValue;
        
        if (this.parent instanceof Bone) {
            this.localAngle = (newValue - this.parent.angle); 
            console.log(this.localAngle, "DEG");
            
        }
    }

    get endPosition() {
        const endPosition = Vector.fromMagnitudeAndAngle(this.length, this.angle);

        if (this.parent instanceof Bone) {
            return this.parent.endPosition.add(endPosition);
        }

        return endPosition.add(this.position);
    }

    set endPosition(other) {
        this.length = Math.sqrt(other.x ** 2 + other.y ** 2);
        this.angle = Math.atan2(other.y, other.x);
    }
}