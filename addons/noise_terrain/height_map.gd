@tool
extends MeshInstance3D

@export_category("Terrain Parameters")
@export var PLANE_SIZE: Vector2i = Vector2i(100, 100):
	set(new_plane_size):
		PLANE_SIZE = new_plane_size
		_update()

@export_range(0, 40) var HEIGHT_MULTIPLIER: int = 20:
	set(new_height_multiplier):
		HEIGHT_MULTIPLIER = new_height_multiplier
		_update_mesh()

@export_category("Terrain Curvature")
@export var REGION_GRADIENT: Gradient
@export var HEIGHT_CURVE: Curve

@export_category("Noise Parameters")
@export var SEED: int = 0:
	set(new_seed):
		SEED = new_seed
		_update()

@export_range(0.0001, 1.) var FREQUENCY: float = 0.005:
	set(new_frequency):
		FREQUENCY = new_frequency
		_update()

@export var OFFSET: Vector2i = Vector2i.ZERO:
	set(new_offset):
		OFFSET = new_offset
		_update()

@export_range(0, 10) var OCTAVES: int = 4:
	set(new_octaves):
		OCTAVES = new_octaves
		_update()

@export_range(1., 10.) var LACUNARITY: float = 1.25:
	set(new_lacunarity):
		LACUNARITY = new_lacunarity
		_update()

@export_range(1., 10.) var GAIN: float = 1.25:
	set(new_gain):
		GAIN = new_gain
		_update()

# Noise generator for height map generation.
var _noise = NoiseGenerator.new()

# Mesh generator for height map generation.
var _mg = MeshGenerator.new()


var _noise_map = Image.new()


func _update_noise_map() -> void:
	var noise_map = _noise.get_noise_map(PLANE_SIZE, SEED, FREQUENCY, OFFSET, OCTAVES, LACUNARITY, GAIN)
	_noise_map.copy_from(noise_map)


func _update_mesh() -> void:
	var mesh_chunk = _mg.generate_chunk(_noise_map, REGION_GRADIENT, HEIGHT_CURVE, HEIGHT_MULTIPLIER)
	mesh = mesh_chunk


func _update() -> void:
	_update_noise_map()
	_update_mesh()


# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	_update()


func _exit_tree() -> void:
	_mg.clear()
