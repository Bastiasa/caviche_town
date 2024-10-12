/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

children_disposition = CANVAS_ITEM_CHILDREN_DISPOSITION.VERTICAL_LAYOUT

vertical_scroll_enabled = true
horizontal_scroll_enabled = false

_scroll_x = 0
_scroll_y = 0
scroll_x = 0
scroll_y = 0

scroll_thumbnail_rounded = false
scroll_thumbnail_color = c_white
scroll_thumbnail_margin = 10

/*function obtenerTamanoContenido(elementos) {
  if (elementos.length === 0) {
    return { ancho: 0, alto: 0 };  // Manejar el caso de array vacío
  }

  // Inicializar valores mínimos y máximos con los primeros elementos
  let minX = elementos[0].x;
  let maxX = elementos[0].x;
  let minY = elementos[0].y;
  let maxY = elementos[0].y;

  // Iterar a través del array para encontrar los valores extremos
  for (let i = 1; i < elementos.length; i++) {
    let elem = elementos[i];
    if (elem.x < minX) minX = elem.x;
    if (elem.x > maxX) maxX = elem.x;
    if (elem.y < minY) minY = elem.y;
    if (elem.y > maxY) maxY = elem.y;
  }

  // Calcular el ancho y el alto
  let ancho = maxX - minX;
  let alto = maxY - minY;

  return { ancho, alto };
}

// Ejemplo de uso
let elementos = [
  { x: 10, y: 20 },
  { x: 40, y: 80 },
  { x: 30, y: 50 },
  // Más elementos...
];
*/

function content_size() {
	if array_length(children) <= 0 {
		return array_create(2, 0)
	}
	
	var _min_x = children[0].x
	var _min_y = children[0].y
	
	var _max_x = children[0].x
	var _max_y = children[0].y
	
	for(var _index = 0; _index < array_length(children); _index++) {
		var _canvas_item = children[_index]
		var _left_top = _canvas_item.get_offset_position()
		var _size = [_canvas_item.get_render_width(), _canvas_item.get_render_height()]
		
		if _min_x > _canvas_item.x { _min_x = _canvas_item.x }
		if _min_y > _canvas_item.y { _min_y = _canvas_item.y }
		
		if _max_x < _canvas_item.y { _max_x }
		
	}
	
	
}