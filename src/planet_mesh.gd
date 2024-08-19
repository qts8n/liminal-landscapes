@tool
extends MeshInstance3D

@export_range(2, 256) var RESOLUTION: int = 10:
	set(new_resolution):
		RESOLUTION = new_resolution
		_update_mesh()

@export var SHAPE_SETTINGS: Shape:
	set(new_shape_settings):
		if SHAPE_SETTINGS != null and SHAPE_SETTINGS.changed.is_connected(_update_mesh):
			SHAPE_SETTINGS.changed.disconnect(_update_mesh)
		SHAPE_SETTINGS = new_shape_settings
		if SHAPE_SETTINGS != null:
			SHAPE_SETTINGS.changed.connect(_update_mesh)

const SECTOR_NORMALS = [
	Vector3.UP,
	Vector3.DOWN,
	Vector3.LEFT,
	Vector3.RIGHT,
	Vector3.FORWARD,
	Vector3.BACK,
]

var _a_mesh = ArrayMesh.new()

var face_generator = FaceGenerator.new(SHAPE_SETTINGS)


func clear() -> void:
	_a_mesh.clear_surfaces()
	_a_mesh.clear_surfaces()
	face_generator.clear()


func _update_settings() -> void:
	face_generator.set_shape(SHAPE_SETTINGS)


func _update_mesh() -> void:
	clear()
	_update_settings()
	for sector_normal in SECTOR_NORMALS:
		face_generator.add_face(_a_mesh, sector_normal, RESOLUTION)
	mesh = _a_mesh


func _enter_tree() -> void:
	_update_mesh()


func _exit_tree() -> void:
	clear()
