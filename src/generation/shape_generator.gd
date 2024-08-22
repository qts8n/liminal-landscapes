extends Node

class_name ShapeGenerator

var _shape: Shape

var _noise_generator: NoiseGenerator


func _init(p_shape: Shape, p_noise: UniformNoise) -> void:
	_shape = p_shape
	_noise_generator = NoiseGenerator.new(p_noise)


func set_shape(p_shape: Shape) -> void:
	_shape = p_shape


func set_noise(p_noise: UniformNoise) -> void:
	_noise_generator.set_noise(p_noise)


func calculate_point_on_planet(point_on_unit_sphere: Vector3) -> Vector3:
	var elevation = _noise_generator.evaluate(point_on_unit_sphere)
	return point_on_unit_sphere * _shape.radius * (1. + elevation)
