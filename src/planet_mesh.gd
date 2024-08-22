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

@export var noise: UniformNoise:
	set(new_noise):
		if noise != null and noise.changed.is_connected(_update_mesh):
			noise.changed.disconnect(_update_mesh)
		noise = new_noise
		if noise != null:
			noise.changed.connect(_update_mesh)


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


func clear() -> void:
	face_generator.clear()


func _update_settings() -> void:
	face_generator.set_shape(shape)


func _update_mesh() -> void:
	clear()
	_update_settings()
	for sector_it in range(SECTOR_NORMALS.size()):
		var sector_normal = SECTOR_NORMALS[sector_it]
		var sector_thread = _sector_threads[sector_it]
		sector_thread.start(face_generator.add_face.bind(sector_normal, resolution))
	_wait_for_threads()
	mesh = face_generator.get_mesh()


func _enter_tree() -> void:
	_update_mesh()


func _exit_tree() -> void:
	clear()