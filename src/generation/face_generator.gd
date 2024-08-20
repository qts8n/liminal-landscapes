extends Node

class_name FaceGenerator


var _verts = PackedVector3Array()
var _uvs = PackedVector2Array()
var _indices = PackedInt32Array()

var _shape_generator: ShapeGenerator


func _init(p_shape: Shape = null) -> void:
	if p_shape == null:
		p_shape = Shape.new()
	_shape_generator = ShapeGenerator.new(p_shape)


func set_shape(p_shape: Shape = null) -> void:
	if p_shape == null:
		p_shape = Shape.new()
	_shape_generator.set_shape(p_shape)


func clear():
	_verts.clear()
	_uvs.clear()
	_indices.clear()


func add_face(mesh: ArrayMesh, normal: Vector3, resolution: int = 50) -> void:
	clear()

	var axis_a = Vector3(normal.y, normal.z, normal.x)
	var axis_a_2 = axis_a * 2.

	var axis_b = normal.cross(axis_a)
	var axis_b_2 = axis_b * 2.

	var edge_c = float(resolution - 1)

	var percent = Vector2.ZERO
	var offset = Vector2.ZERO

	var vertex_i = 0

	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	# Let's assume, resolution = n, the complexity will be
	# O(n^2), where n is the number of vertices on one side of the face,
	# hance O(n^2) = O(m), where m is the total number of vertices.
	for y in range(resolution):
		percent.y = y / edge_c
		offset.y = percent.y - .5
		var offset_b = offset.y * axis_b_2
		var normal_offset_b = normal + offset_b
		for x in range(resolution):
			percent.x = x / edge_c
			offset.x = percent.x - .5
			var offset_a = offset.x * axis_a_2
			var point_on_unit_cube = normal_offset_b + offset_a
			var point_on_unit_sphere = point_on_unit_cube.normalized()
			var vertex = _shape_generator.calculate_point_on_planet(point_on_unit_sphere)
			_uvs.append(percent)
			st.set_uv(percent)

			st.set_color(Color.RED)

			_verts.append(vertex)
			st.add_vertex(vertex)
			if x != edge_c and y != edge_c:
				var vertex_i_1 = vertex_i + 1
				var vertex_i_y = vertex_i + resolution
				var vertex_i_y_1 = vertex_i_y + 1

				_indices.append(vertex_i)
				st.add_index(vertex_i)
				_indices.append(vertex_i_y_1)
				st.add_index(vertex_i_y_1)
				_indices.append(vertex_i_y)
				st.add_index(vertex_i_y)

				_indices.append(vertex_i)
				st.add_index(vertex_i)
				_indices.append(vertex_i_1)
				st.add_index(vertex_i_1)
				_indices.append(vertex_i_y_1)
				st.add_index(vertex_i_y_1)

			vertex_i += 1

	st.generate_normals()
	st.generate_tangents()
	st.commit(mesh)
