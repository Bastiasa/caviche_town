/// @description Inserte aquí la descripción
// Puede escribir su código en este editor

// Inherit the parent event
event_inherited();

children_disposition = CANVAS_ITEM_CHILDREN_DISPOSITION.VERTICAL_LAYOUT

vertical_scroll_enabled = true
horizontal_scroll_enabled = false

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

function get_min_and_max_position() {
    if array_length(children) <= 0 {
        return array_create(2, 0);
    }
    
    var _min_x = children[0].x;
    var _min_y = children[0].y;
    
    var _max_x = children[0].x;
    var _max_y = children[0].y;
    

    for (var _index = 0; _index < array_length(children); _index++) {
        var _canvas_item = children[_index];
        
        var _left_top = _canvas_item.get_offset_position(0, 0);
        var _right_top = _canvas_item.get_offset_position(1, 0);
        var _left_bottom = _canvas_item.get_offset_position(0, 1);
        var _right_bottom = _canvas_item.get_offset_position(1, 1); 
        
        _min_x = min(_min_x, _left_top[0], _right_top[0], _left_bottom[0], _right_bottom[0]);
        _min_y = min(_min_y, _left_top[1], _right_top[1], _left_bottom[1], _right_bottom[1]);
        
        _max_x = max(_max_x, _left_top[0], _right_top[0], _left_bottom[0], _right_bottom[0]);
        _max_y = max(_max_y, _left_top[1], _right_top[1], _left_bottom[1], _right_bottom[1]);
    }


    return [[_min_x, _min_y], [_max_x, _max_y]];
}