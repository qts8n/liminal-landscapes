extends Node

class_name FaceGenerator


var _shape_generator: ShapeGenerator

var _a_mesh: ArrayMesh

signal changed


func _init(p_shape: Shape = null) -> void:
	_a_mesh = ArrayMesh.new()
	if p_shape == null:
		p_shape = Shape.new()
	_shape_generator = ShapeGenerator.new(p_shape)


func _update_mesh(surface_array) -> void:
	_a_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	changed.emit()


func set_shape(p_shape: Shape = null) -> void:
	if p_shape == null:
		p_shape = Shape.new()
	_shape_generator.set_shape(p_shape)


func clear():
	_a_mesh.clear_surfaces()


func get_mesh() -> ArrayMesh:
	return _a_mesh


func add_face(normal: Vector3, resolution: int = 50) -> void:
	var verts = PackedVector3Array()
	var uvs = PackedVector2Array()
	var indices = PackedInt32Array()
	var normals = PackedVector3Array()

	var axis_a = Vector3(normal.y, normal.z, normal.x)
	var axis_a_2 = axis_a * 2.

	var axis_b = normal.cross(axis_a)
	var axis_b_2 = axis_b * 2.

	var edge_c = float(resolution - 1)

	var percent = Vector2.ZERO
	var offset = Vector2.ZERO

	var vertex_i = 0
	var num_vertices = resolution * resolution

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
			uvs.append(percent)
			verts.append(vertex)
			normals.append(Vector3.ZERO)

			if x != edge_c and y != edge_c:
				var vertex_i_1 = vertex_i + 1
				var vertex_i_y = vertex_i + resolution
				var vertex_i_y_1 = vertex_i_y + 1

				indices.append(vertex_i_y)
				indices.append(vertex_i_y_1)
				indices.append(vertex_i)

				indices.append(vertex_i_y_1)
				indices.append(vertex_i_1)
				indices.append(vertex_i)

			vertex_i += 1

	for a in range(0, indices.size(), 3):
		var b = a + 1
		var c = a + 2

		var a_i = indices[a]
		var b_i = indices[b]
		var c_i = indices[c]

		var vert_a = verts[a_i]
		var vert_b = verts[b_i]
		var vert_c = verts[c_i]

		var ab = vert_b - vert_a
		var bc = vert_c - vert_b
		var ca = vert_a - vert_c

		var cross_ab_bc = ab.cross(bc) * -1.
		var cross_bc_ca = bc.cross(ca) * -1.
		var cross_ca_ab = ca.cross(ab) * -1.

		var triangle_normal = cross_ab_bc + cross_bc_ca + cross_ca_ab
		normals[a_i] += triangle_normal
		normals[b_i] += triangle_normal
		normals[c_i] += triangle_normal

	for it in range(num_vertices):
		normals[it] = normals[it].normalized()

	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	surface_array[Mesh.ARRAY_VERTEX] = verts
	surface_array[Mesh.ARRAY_TEX_UV] = uvs
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices

	call_deferred("_update_mesh", surface_array)
