extends Camera3D

@export var viewport_path : NodePath

@onready var viewport : SubViewport = get_node(viewport_path)


func _process(delta) -> void:
	var source_camera = get_node(viewport_path).get_camera_3d()
	global_transform = source_camera.global_transform
	# TO DO - fix camera rotation
