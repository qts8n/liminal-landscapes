extends Node

class_name ShapeGenerator

var _shape: Shape


func _init(p_shape: Shape) -> void:
	_shape = p_shape


func set_shape(p_shape: Shape) -> void:
	_shape = p_shape


func calculate_point_on_planet(point_on_unit_sphere: Vector3) -> Vector3:
	return point_on_unit_sphere * _shape.radius
