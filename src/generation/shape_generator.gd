extends Node

class_name ShapeGenerator

var _shape: Shape

var _noise_filters: Array[NoiseFilter] = []

var _num_layers: int = 0
var _first_filter: NoiseFilter = null
var _filter_slice: Array[NoiseFilter] = []


func _init(p_shape: Shape) -> void:
	set_shape(p_shape)


func set_shape(p_shape: Shape) -> void:
	_noise_filters.clear()
	_shape = p_shape
	for noise in _shape.noise_layers:
		if noise != null:
			_noise_filters.append(NoiseFilterFactory.create_noise_filter(noise))
	_num_layers = _noise_filters.size()
	if _num_layers > 0:
		_first_filter = _noise_filters[0]
		_filter_slice = _noise_filters.slice(1)
	else:
		_first_filter = null
		_filter_slice = []



func calculate_point_on_planet(point_on_unit_sphere: Vector3) -> Vector3:
	var point_on_shape = point_on_unit_sphere * _shape.radius
	if _num_layers == 0 or _first_filter == null:
		return point_on_shape

	var elevation = 0.
	var first_layer_elevation = _first_filter.evaluate(point_on_unit_sphere)
	if _first_filter.is_enabled():
		elevation = first_layer_elevation

	for filter in _filter_slice:
		if filter == null or not filter.is_enabled():
			continue
		var mask = 1.
		if _shape.first_layer_mask:
			mask = first_layer_elevation
		elevation += filter.evaluate(point_on_unit_sphere) * mask
	return point_on_shape * (1. + elevation)
