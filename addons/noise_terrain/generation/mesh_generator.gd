extends Node

class_name MeshGenerator

var _noise = NoiseGenerator.new()

# ArrayMesh instance
var _a_mesh = ArrayMesh.new()

# PackedVector**Arrays for mesh construction.
var _verts = PackedVector3Array()
var _uvs = PackedVector2Array()
var _normals = PackedVector3Array()
var _indices = PackedInt32Array()
var _colors = PackedColorArray()
var _color_map = Image.new()


func clear() -> void:
	_verts.clear()
	_uvs.clear()
	_normals.clear()
	_indices.clear()
	_colors.clear()

	_a_mesh.clear_surfaces()
	_a_mesh.clear_blend_shapes()


func _add_triangle(st: SurfaceTool, a: int, b: int, c: int):
	_indices.append(a)
	st.add_index(a)

	_indices.append(b)
	st.add_index(b)

	_indices.append(c)
	st.add_index(c)


func generate_chunk(
	noise_map: Image,
	regional_gradient: Gradient,
	height_curve: Curve,
	height_multiplier: float = 20.,
) -> ArrayMesh:
	clear()

	var map_width = noise_map.get_width()
	var map_height = noise_map.get_height()

	var edge_x = map_width - 1
	var edge_y = map_height - 1
	var top_left_x = edge_x / -2.
	var top_left_z = edge_y / 2.
	var max_u = float(map_width)
	var max_v = float(map_height)

	var region_num = regional_gradient.offsets.size()
	_color_map.copy_from(noise_map)
	_color_map.convert(Image.FORMAT_RGB8)

	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	var vertex_i = 0
	for y in range(map_height):
		for x in range(map_width):
			var noise_value = noise_map.get_pixel(x, y).r
			for region_it in range(region_num):
				var region_height = regional_gradient.get_offset(region_it)

				if noise_value <= region_height:
					var region_color = regional_gradient.get_color(region_it)
					_color_map.set_pixel(x, y, region_color)
					_colors.append(region_color)
					st.set_color(region_color)
					break

			var uv = Vector2(x / max_u, y / max_v)
			_uvs.append(uv)
			st.set_uv(uv)

			var normal = Vector3.UP
			_normals.append(normal)
			st.set_normal(normal)

			var height = height_curve.sample(noise_value) * height_multiplier
			var vertex = Vector3(top_left_x + x, height, top_left_z - y)
			_verts.append(vertex)
			st.add_vertex(vertex)

			if x < edge_x and y < edge_y:
				var next_row_i = vertex_i + map_width
				_add_triangle(st, vertex_i, next_row_i, next_row_i + 1)
				_add_triangle(st, next_row_i + 1, vertex_i + 1, vertex_i)
			vertex_i += 1

	st.generate_normals()
	st.generate_tangents()
	st.commit(_a_mesh)

	var material = StandardMaterial3D.new()
	material.albedo_texture = ImageTexture.create_from_image(_color_map)
	material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	_a_mesh.surface_set_material(0, material)

	return _a_mesh
