extends NoiseFilter

class_name SimpleNoiseFilter


func evaluate(point: Vector3) -> float:
	var noise_value = 0.
	var frequency = _noise.base_roughness
	var amplitude = 1.
	for it in range(_noise.num_layers):
		var v = get_noise(point, frequency)
		noise_value += (v + 1) * .5 * amplitude
		frequency *= _noise.roughness
		amplitude *= _noise.persistence
	noise_value = maxf(0, noise_value - _noise.min_value)
	return noise_value * _noise.strength
