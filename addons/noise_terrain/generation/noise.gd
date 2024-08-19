extends Node

class_name NoiseGenerator

var _noise = FastNoiseLite.new()


func get_noise_map(
	size: Vector2i,
	random_seed: int,
	freq: float,
	offset: Vector2,
	octaves: int,
	lacunarity: float,
	gain: float
) -> Image:
	_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	_noise.fractal_type = FastNoiseLite.FRACTAL_FBM

	_noise.seed = random_seed

	_noise.frequency = freq
	_noise.offset = Vector3(offset.x, 0., offset.y)
	_noise.fractal_octaves = octaves
	_noise.fractal_lacunarity = lacunarity
	_noise.fractal_gain = gain

	return _noise.get_seamless_image(size.x, size.y)
