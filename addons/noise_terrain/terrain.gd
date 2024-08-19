@tool
extends EditorPlugin


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	add_custom_type("NoiseTerrain", "MeshInstance3D", preload("height_map.gd"), preload("icon.png"))


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_custom_type("NoiseTerrain")
