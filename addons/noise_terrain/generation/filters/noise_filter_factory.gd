extends Node

class_name NoiseFilterFactory


static func create_noise_filter(noise: UniformNoise) -> NoiseFilter:
	if noise.noise_settings.filter_type == NoiseSettings.FilterType.SIMPLE:
		return SimpleNoiseFilter.new(noise)
	elif noise.noise_settings.filter_type == NoiseSettings.FilterType.RIDGED:
		return RidgedNoiseFilter.new(noise)
	return NoiseFilter.new(noise)
