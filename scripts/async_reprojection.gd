extends Node3D

@export var viewport_path : NodePath
@export var timer_path : NodePath
@export var target_fps : int = 15

@onready var viewport : SubViewport = get_node(viewport_path)


func _ready() -> void:
	var timer = get_node(timer_path)
	var frame_duration = 1.0/float(target_fps)
	timer.start(frame_duration)

func _on_timer_timeout():
	viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
