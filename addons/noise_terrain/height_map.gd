@tool
extends MeshInstance3D

@export_category("Terrain parameters")
@export var PLANE_SIZE: Vector2i = Vector2i(100, 100)
@export var REGION_GRADIENT: Gradient
@export_range(0, 40) var HEIGHT_MULTIPLIER: int = 20
@export var HEIGHT_CURVE: Curve

@export_category("Noise Parameters")
@export var SEED: int = 0
@export_range(0.0001, 1.) var FREQUENCY: float = 0.005
@export var OFFSET: Vector2i = Vector2i.ZERO
@export_range(0, 10) var OCTAVES: int = 4
@export_range(1., 10.) var LACUNARITY: float = 1.25
@export_range(1., 10.) var GAIN: float = 1.25

# Noise generator for height map generation.
var _noise = NoiseGenerator.new()

# Mesh generator for height map generation.
var _mg = MeshGenerator.new()


# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	var noise_map = _noise.get_noise_map(PLANE_SIZE, SEED, FREQUENCY, OFFSET, OCTAVES, LACUNARITY, GAIN)
	var mesh_chunk = _mg.generate_chunk(noise_map, REGION_GRADIENT, HEIGHT_CURVE, HEIGHT_MULTIPLIER)
	mesh = mesh_chunk


func _exit_tree() -> void:
	_mg.clear()
