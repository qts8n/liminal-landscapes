@tool
extends MeshInstance3D

const SECTOR_NORMALS = [
	Vector3.UP,
	Vector3.DOWN,
	Vector3.LEFT,
	Vector3.RIGHT,
	Vector3.FORWARD,
	Vector3.BACK,
]

@export_range(2, 256) var resolution: int = 10:
	set(new_resolution):
		resolution = new_resolution
		_update_mesh()

@export var shape: Shape:
	set(new_shape_settings):
		if shape != null and shape.changed.is_connected(_update_mesh):
			shape.changed.disconnect(_update_mesh)
		shape = new_shape_settings
		if shape != null:
			shape.changed.connect(_update_mesh)
		_update_mesh()

@export var planet_material: Material:
	set(new_planet_material):
		planet_material = new_planet_material
		_process_mesh()

@export var apply_material: bool = true:
	set(new_apply_material):
		apply_material = new_apply_material
		_process_mesh()

var face_generator = FaceGenerator.new(shape)

var _sector_threads = [
	Thread.new(),
	Thread.new(),
	Thread.new(),
	Thread.new(),
	Thread.new(),
	Thread.new(),
]


func _wait_for_threads() -> void:
	for sector_thread: Thread in _sector_threads:
		sector_thread.wait_to_finish()


func _update_mesh() -> void:
	face_generator.clear()
	face_generator.set_shape(shape)
	for sector_it in range(SECTOR_NORMALS.size()):
		var sector_normal = SECTOR_NORMALS[sector_it]
		var sector_thread = _sector_threads[sector_it]
		sector_thread.start(face_generator.add_face.bind(sector_normal, resolution))
	_wait_for_threads()


func _process_mesh() -> void:
	mesh = face_generator.get_mesh()
	for surface_idx in range(mesh.get_surface_count()):
		if apply_material:
			mesh.surface_set_material(surface_idx, planet_material)
		else:
			mesh.surface_set_material(surface_idx, null)
		planet_material.set_shader_parameter("elevation_minmax", face_generator.get_minmax())



func _enter_tree() -> void:
	face_generator.changed.connect(_process_mesh)


func _exit_tree() -> void:
	face_generator.changed.disconnect(_process_mesh)
