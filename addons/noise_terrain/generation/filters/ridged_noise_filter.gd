extends NoiseFilter

class_name RidgedNoiseFilter


func evaluate(point: Vector3) -> float:
	var noise_value = 0.
	var frequency = _noise.noise_settings.base_roughness
	var amplitude = 1.
	var weight = 1.
	for it in range(_noise.noise_settings.num_layers):
		var v = 1. - absf(get_noise(point, frequency))
		v *= v * weight
		weight = v

		noise_value += v * amplitude
		frequency *= _noise.noise_settings.roughness
		amplitude *= _noise.noise_settings.persistence
	noise_value = maxf(0, noise_value - _noise.noise_settings.min_value)
	return noise_value * _noise.noise_settings.strength
