/// @description Inserte aquí la descripción
// Puede escribir su código en este editor


for(var _hit_particle_index = 0; _hit_particle_index < array_length(hit_particles); _hit_particle_index++) {
	var _hit_particle_data = hit_particles[_hit_particle_index]
	
	if !variable_struct_exists(_hit_particle_data, "_lifetime") {
		_hit_particle_data._lifetime = _hit_particle_data.lifetime
	}
	
	_hit_particle_data.lifetime -= get_delta()
	
	if _hit_particle_data.lifetime <= 0 {
		array_delete(hit_particles, _hit_particle_index, 1)
		continue
	}
	
	var _character_size = _hit_particle_data.character.get_sprite_size()
	
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	
	draw_set_alpha(_hit_particle_data.lifetime / 0.3)
	
	var _scale_in = 0.3
	
	var _scale_in_end = _hit_particle_data._lifetime - _scale_in
	var _scale_in_lifetime = _hit_particle_data.lifetime - _scale_in_end
	
	var _scale = _scale_in_lifetime / _scale_in * 2
	_scale = max(1.3, _scale)
	
	draw_text_transformed(
		_hit_particle_data.character.x + abs(_character_size.x) + 20,
		_hit_particle_data.character.y - _character_size.y - 20,
		string(round(_hit_particle_data.damage)),
		_scale,
		_scale,
		_hit_particle_data.rotation
	)
	
	draw_set_alpha(1)
}