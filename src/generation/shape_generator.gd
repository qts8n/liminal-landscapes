extends Node

class_name ShapeGenerator

var _shape_settings: Shape


func _init(p_shape_setting: Shape) -> void:
	_shape_settings = p_shape_setting


func set_shape(p_shape_setting: Shape) -> void:
	_shape_settings = p_shape_setting


func calculate_point_on_planet(point_on_unit_sphere: Vector3) -> Vector3:
	return point_on_unit_sphere * _shape_settings.radius
