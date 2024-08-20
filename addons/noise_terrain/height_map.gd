@tool
extends MeshInstance3D

@export_category("Terrain Parameters")
@export var plane_size: Vector2i = Vector2i(100, 100):
	set(new_plane_size):
		plane_size = new_plane_size
		_update_mesh()

@export_range(0, 40) var height_multiplier: int = 20:
	set(new_height_multiplier):
		height_multiplier = new_height_multiplier
		_update_mesh()

@export var noise: UniformNoise:
	set(new_noise):
		if noise != null and noise.changed.is_connected(_update_mesh):
			noise.changed.disconnect(_update_mesh)
		noise = new_noise
		if noise != null:
			noise.changed.connect(_update_mesh)

@export_category("Terrain Curvature")
@export var region_gradient: Gradient
@export var height_curve: Curve


# Mesh generator for height map generation.
var _mg = MeshGenerator.new(noise)


func _update_mesh() -> void:
	_mg.set_noise(noise)
	var mesh_chunk = _mg.generate_chunk(plane_size, region_gradient, height_curve, height_multiplier)
	mesh = mesh_chunk


# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	_update_mesh()


func _exit_tree() -> void:
	_mg.clear()
