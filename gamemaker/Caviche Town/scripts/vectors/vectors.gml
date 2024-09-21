
function Vector(_x,_y) {
	var this = {
		x:_x,
		y:_y,
		
		magnitude:function() {
			return sqrt(power(_x,2)+power(_y,2))
		},
		
		direction: function() {
			return point_direction(0,0,_x,_y)
		}
	}
}
	
vector_operations = {
	negative: function(_vector) {
		return Vector(-_vector.x, -_vector.y)
	},

	add:function(_vec1, _vec2) {
		return Vector(_vec1.x + _vec2.x, _vec1.y + _vec2.y)
	},

	subtract_vector:function (_vec1,_vec2) {
		return vector_operations.add(_vec1, vector_operations.negative(_vec2))
	}

	function multiply_vector(_vector, _other) {
		if is_numeric(_other) {
			return multiply_vector(_vector, Vector(_other,_other))
		} else {
			return Vector(_vector.x*_other.x, _vector.y*_other.y)
		}
	}

	function divide_vector(_vector, _other) {
		if is_numeric(_other) {
			return multiply_vector(_vector, Vector(1.0/_other, 1.0/_other))
		} else {
			return multiply_vector(_vector, Vector(1.0/_other.x, 1.0/_other.y))
		}
	}

	function vector_magnitude(_vector) {
		return sqrt(power(_vector.x,2) +power(_vector.y, 2))
	}

	function vector_direction(_vector) {
		return arctan(_vector.y/_vector.x)
	}
}


