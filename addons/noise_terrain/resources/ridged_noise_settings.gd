extends NoiseSettings

class_name RidgedNoiseSettings

@export_range(0, 1) var weight_scalar: float = .8:
	set(new_weight_scalar):
		weight_scalar = new_weight_scalar
		changed.emit()


func _init():
	filter_type = FilterType.RIDGED
