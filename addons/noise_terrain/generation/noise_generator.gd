extends Node

class_name NoiseGenerator

var _ng: FastNoiseLite

var _noise: UniformNoise


func _init(p_noise: UniformNoise) -> void:
	_ng = FastNoiseLite.new()
	_ng.noise_type = FastNoiseLite.TYPE_SIMPLEX
	_ng.fractal_type = FastNoiseLite.FRACTAL_FBM

	set_noise(p_noise)


func set_noise(p_noise: UniformNoise) -> void:
	_noise = p_noise

	_ng.seed = _noise.seed
	_ng.frequency = _noise.frequency
	_ng.offset = Vector3(_noise.offset.x, 0., _noise.offset.y)
	_ng.fractal_octaves = _noise.octaves
	_ng.fractal_lacunarity = _noise.lacunarity
	_ng.fractal_gain = _noise.gain


func get_noise_map(size: Vector2i) -> Image:
	return _ng.get_seamless_image(size.x, size.y)


func evaluate(point: Vector3) -> float:
	var noise_value = (_ng.get_noise_3dv(point * _noise.roughness + _noise.center) + 1) * .5
	return noise_value * _noise.strength
