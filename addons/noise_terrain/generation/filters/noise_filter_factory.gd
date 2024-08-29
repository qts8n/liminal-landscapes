extends Node

class_name NoiseFilterFactory


static func create_noise_filter(noise: UniformNoise) -> NoiseFilter:
	if noise.filter_type == UniformNoise.FilterType.SIMPLE:
		return SimpleNoiseFilter.new(noise)
	elif noise.filter_type == UniformNoise.FilterType.RIDGED:
		return RidgedNoiseFilter.new(noise)
	return NoiseFilter.new(noise)
