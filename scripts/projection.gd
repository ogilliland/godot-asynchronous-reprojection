extends MeshInstance3D

@export var viewport_path : NodePath

var viewport : SubViewport


func _ready() -> void:
	viewport = get_node(viewport_path)
	
	_resize()
	get_tree().get_root().size_changed.connect(_resize)
	
	var viewport_texture = viewport.get_texture()
	mesh.material.set_shader_parameter("albedo_texture", viewport_texture)


func _resize() -> void:
	viewport.size = DisplayServer.window_get_size()
