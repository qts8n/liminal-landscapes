@tool
extends Resource

class_name Shape

@export var radius: float = 1.:
	set(new_radius):
		radius = new_radius
		changed.emit()

@export var first_layer_mask: bool = true:
	set(new_first_layer_mask):
		first_layer_mask = new_first_layer_mask
		changed.emit()

@export var noise_layers: Array[UniformNoise] = []:
	set(new_noise_layers):
		for noise in noise_layers:
			if noise != null and noise.changed.is_connected(_update_shape):
				noise.changed.disconnect(_update_shape)
		noise_layers = new_noise_layers
		for noise in noise_layers:
			if noise != null:
				noise.changed.connect(_update_shape)
		_update_shape()


func _update_shape() -> void:
	changed.emit()
