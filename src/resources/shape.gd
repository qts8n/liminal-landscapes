@tool
extends Resource

class_name Shape

@export var radius: float:
	set(new_radius):
		radius = new_radius
		changed.emit()


func _init(p_radius: float = 1.) -> void:
	radius = p_radius
