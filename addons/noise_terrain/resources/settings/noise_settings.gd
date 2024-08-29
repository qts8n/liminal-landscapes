@tool
extends Resource

class_name NoiseSettings

enum FilterType {NIL, SIMPLE, RIDGED}

var filter_type: FilterType = FilterType.NIL

@export var strength: float = 1.:
	set(new_strength):
		strength = new_strength
		changed.emit()
@export_range(1, 8) var num_layers: int = 1:
	set(new_num_layers):
		num_layers = new_num_layers
		changed.emit()
@export var base_roughness: float = 1.:
	set(new_base_roughness):
		base_roughness = new_base_roughness
		changed.emit()
@export var roughness: float = 2.:
	set(new_roughness):
		roughness = new_roughness
		changed.emit()
@export var persistence: float = .5:
	set(new_persistence):
		persistence = new_persistence
		changed.emit()
@export var center: Vector3 = Vector3.ZERO:
	set(new_center):
		center = new_center
		changed.emit()
@export var min_value: float = 0.:
	set(new_min_value):
		min_value = new_min_value
		changed.emit()


func _init():
	filter_type = FilterType.NIL
