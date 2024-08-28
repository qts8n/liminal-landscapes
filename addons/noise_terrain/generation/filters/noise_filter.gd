extends NoiseGenerator

class_name NoiseFilter


func get_noise(point: Vector3, frequency: float = 1.) -> float:
	return _ng.get_noise_3dv(point * frequency + _noise.center)


func evaluate(point: Vector3) -> float:
	return get_noise(point, _noise.base_roughness)
