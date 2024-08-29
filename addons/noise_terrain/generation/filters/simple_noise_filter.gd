extends NoiseFilter

class_name SimpleNoiseFilter


func evaluate(point: Vector3) -> float:
	var noise_value = 0.
	var frequency = _noise.noise_settings.base_roughness
	var amplitude = 1.
	for it in range(_noise.noise_settings.num_layers):
		var v = get_noise(point, frequency)
		noise_value += (v + 1) * .5 * amplitude
		frequency *= _noise.noise_settings.roughness
		amplitude *= _noise.noise_settings.persistence
	noise_value = maxf(0, noise_value - _noise.noise_settings.min_value)
	return noise_value * _noise.noise_settings.strength
