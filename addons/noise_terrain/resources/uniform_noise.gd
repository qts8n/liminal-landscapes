@icon("../icon.png")
@tool
extends Resource

class_name UniformNoise

@export var enabled: bool = true:
	set(new_enabled):
		enabled = new_enabled
		changed.emit()

@export_group("Noise Parameters")

enum FilterType {SIMPLE, RIDGED}

@export var filter_type: FilterType = FilterType.SIMPLE:
	set(new_filter_type):
		filter_type = new_filter_type
		changed.emit()
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

@export_group("Noise Algorithm Parameters")
@export var seed: int = 0:
	set(new_seed):
		seed = new_seed
		changed.emit()
@export_range(0.0001, 1.) var frequency: float = 0.005:
	set(new_frequency):
		frequency = new_frequency
		changed.emit()
@export var offset: Vector2i = Vector2i.ZERO:
	set(new_offset):
		offset = new_offset
		changed.emit()
@export_range(0, 10) var octaves: int = 4:
	set(new_octaves):
		octaves = new_octaves
		changed.emit()
@export_range(1., 10.) var lacunarity: float = 1.25:
	set(new_lacunarity):
		lacunarity = new_lacunarity
		changed.emit()
@export_range(1., 10.) var gain: float = 1.25:
	set(new_gain):
		gain = new_gain
		changed.emit()
