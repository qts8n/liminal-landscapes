extends Node

class_name NoiseGenerator

var _ng = FastNoiseLite.new()

var _noise: UniformNoise


func _init(p_noise: UniformNoise) -> void:
	_noise = p_noise


func set_noise(p_noise: UniformNoise) -> void:
	_noise = p_noise


func get_noise_map(size: Vector2i) -> Image:
	_ng.noise_type = FastNoiseLite.TYPE_SIMPLEX
	_ng.fractal_type = FastNoiseLite.FRACTAL_FBM

	_ng.seed = _noise.seed

	_ng.frequency = _noise.frequency
	_ng.offset = Vector3(_noise.offset.x, 0., _noise.offset.y)
	_ng.fractal_octaves = _noise.octaves
	_ng.fractal_lacunarity = _noise.lacunarity
	_ng.fractal_gain = _noise.gain

	return _ng.get_seamless_image(size.x, size.y)
