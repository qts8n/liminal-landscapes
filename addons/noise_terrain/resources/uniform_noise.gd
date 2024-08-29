@icon("../icon.png")
@tool
extends Resource

class_name UniformNoise

var _default_noise_settings = NoiseSettings.new()

@export var enabled: bool = true:
	set(new_enabled):
		enabled = new_enabled
		_update_noise()

@export var noise_settings: NoiseSettings:
	get:
		if noise_settings == null:
			return _default_noise_settings
		return noise_settings
	set(new_noise_settings):
		if noise_settings != null and noise_settings.changed.is_connected(_update_noise):
			noise_settings.changed.disconnect(_update_noise)
		noise_settings = new_noise_settings
		if noise_settings != null:
			noise_settings.changed.connect(_update_noise)
		_update_noise()

@export_group("Noise Parameters")
@export var seed: int = 0:
	set(new_seed):
		seed = new_seed
		_update_noise()
@export_range(0.0001, 1.) var frequency: float = 0.005:
	set(new_frequency):
		frequency = new_frequency
		_update_noise()
@export var offset: Vector2i = Vector2i.ZERO:
	set(new_offset):
		offset = new_offset
		_update_noise()
@export_range(0, 10) var octaves: int = 4:
	set(new_octaves):
		octaves = new_octaves
		_update_noise()
@export_range(1., 10.) var lacunarity: float = 1.25:
	set(new_lacunarity):
		lacunarity = new_lacunarity
		_update_noise()
@export_range(1., 10.) var gain: float = 1.25:
	set(new_gain):
		gain = new_gain
		_update_noise()


func _update_noise():
	changed.emit()
