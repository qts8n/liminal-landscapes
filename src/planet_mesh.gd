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

var _a_mesh = ArrayMesh.new()

var face_generator = FaceGenerator.new(shape)


func clear() -> void:
	_a_mesh.clear_surfaces()
	_a_mesh.clear_surfaces()
	face_generator.clear()


func _update_settings() -> void:
	face_generator.set_shape(shape)


func _update_mesh() -> void:
	clear()
	_update_settings()
	for sector_normal in SECTOR_NORMALS:
		face_generator.add_face(_a_mesh, sector_normal, resolution)
	mesh = _a_mesh


func _enter_tree() -> void:
	_update_mesh()


func _exit_tree() -> void:
	clear()
