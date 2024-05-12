@tool
extends MeshInstance3D

@export var UPDATE: bool = false
@export var PLANE_SIZE: Vector2i = Vector2i(100, 100)

@export_category("Noise Parameters")
@export var SEED: int = 0
@export_range(0.0001, 1.) var FREQUENCY: float = 0.005
@export var OFFSET: Vector2i = Vector2i.ZERO
@export_range(0, 10) var OCTAVES: int = 4
@export_range(1., 10.) var LACUNARITY: float = 1.25
@export_range(1., 10.) var GAIN: float = 1.25

# Noise generator for height map generation.
var _noise = NoiseGenerator.new()

# ArrayMesh instance
var _a_mesh = ArrayMesh.new()

# PackedVector**Arrays for mesh construction.
var _verts = PackedVector3Array()
var _uvs = PackedVector2Array()
var _normals = PackedVector3Array()
var _indices = PackedInt32Array()


func _add_triangle(a: int, b: int, c: int):
	_indices.append(a)
	_indices.append(b)
	_indices.append(c)


func _update_a_mesh(noise_map: Image):
	_a_mesh.clear_surfaces()
	_verts.clear()
	_uvs.clear()
	_normals.clear()
	_indices.clear()

	var edge_x = PLANE_SIZE.x - 1
	var edge_y = PLANE_SIZE.y - 1
	var top_left_x = edge_x / -2.
	var top_left_z = edge_y / 2.
	var max_u = float(PLANE_SIZE.x)
	var max_v = float(PLANE_SIZE.y)

	#var color_map = Image.new()
	#color_map.copy_from(noise_map)

	var vertex_i = 0
	for y in range(PLANE_SIZE.y):
		for x in range(PLANE_SIZE.x):
			var height = noise_map.get_pixel(x, y).r
			_verts.append(Vector3(top_left_x + x, height, top_left_z - y))
			_uvs.append(Vector2(x / max_u, y / max_v))
			_normals.append(Vector3.UP)
			if x < edge_x and y < edge_y:
				var next_row_i = vertex_i + PLANE_SIZE.x
				_add_triangle(vertex_i, next_row_i, next_row_i + 1)
				_add_triangle(next_row_i + 1, vertex_i + 1, vertex_i)
			vertex_i += 1

	# Assign arrays to surface array.
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	surface_array[Mesh.ARRAY_VERTEX] = _verts
	surface_array[Mesh.ARRAY_TEX_UV] = _uvs
	surface_array[Mesh.ARRAY_NORMAL] = _normals
	surface_array[Mesh.ARRAY_INDEX] = _indices

	# Create mesh surface from mesh array.
	# No blendshapes, lods, or compression used.
	_a_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	_a_mesh.surface_set_name(0, "Terrain")


func _generate_mesh():
	var noise_map = _noise.get_noise_map(PLANE_SIZE, SEED, FREQUENCY, OFFSET, OCTAVES, LACUNARITY, GAIN)
	_update_a_mesh(noise_map)
	mesh = _a_mesh


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_generate_mesh()


func _process(_delta: float) -> void:
	if not UPDATE:
		return
	_generate_mesh()
	UPDATE = false
