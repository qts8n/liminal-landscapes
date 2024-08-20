@tool
extends Resource

class_name Shape

@export var radius: float = 1.:
	set(new_radius):
		radius = new_radius
		changed.emit()
