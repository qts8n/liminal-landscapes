extends Node

class_name ShapeGenerator


class ElevationMinMax:
	const FLOAT32_MAX: float = 2. ** 126
	const FLOAT32_MIN: float = -FLOAT32_MAX

	var _elevation_min: float
	var _elevation_max: float

	func _init() -> void:
		reset()

	func reset() -> void:
		_elevation_min = FLOAT32_MAX
		_elevation_max = FLOAT32_MIN

	func add_value(v: float) -> void:
		if v > _elevation_max:
			_elevation_max = v
		if v < _elevation_min:
			_elevation_min = v

	func get_min() -> float:
		return _elevation_min

	func get_max() -> float:
		return _elevation_max

	func get_minmax() -> Vector2:
		return Vector2(_elevation_min, _elevation_max)


var _shape: Shape

var _noise_filters: Array[NoiseFilter] = []

var _num_layers: int = 0

var _first_filter: NoiseFilter = null

var _filter_slice: Array[NoiseFilter] = []

var _elevation_minmax = ElevationMinMax.new()


func _init(p_shape: Shape) -> void:
	set_shape(p_shape)


func clear():
	_elevation_minmax.reset()


func get_minmax() -> Vector2:
	return _elevation_minmax.get_minmax()


func set_shape(p_shape: Shape) -> void:
	_noise_filters.clear()
	_shape = p_shape
	for noise in _shape.noise_layers:
		if noise == null:
			continue
		_noise_filters.append(NoiseFilterFactory.create_noise_filter(noise))
	_num_layers = _noise_filters.size()
	if _num_layers > 0:
		_first_filter = _noise_filters[0]
		_filter_slice = _noise_filters.slice(1)
	else:
		_first_filter = null
		_filter_slice = []


func calculate_point_on_planet(point_on_unit_sphere: Vector3) -> Vector3:
	if _num_layers == 0 or _first_filter == null:
		return point_on_unit_sphere * _shape.radius

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
	elevation = _shape.radius * (1. + elevation)
	_elevation_minmax.add_value(elevation)
	return point_on_unit_sphere * elevation
