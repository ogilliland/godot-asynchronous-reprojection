extends CharacterBody3D

const ACCEL : int = 8
const DEACCEL : int = 16
const SPEED : float= 5.0
const JUMP_VELOCITY : float = 4.5

var vel := Vector3(0, 0, 0)
var dir := Vector3(0, 0, 0)
var mouse_sensitivity : float = 0.25

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var rotation_helper : Node = get_node("RotationHelper")
@onready var world_camera : Node = get_node("RotationHelper/Camera3D")


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta: float) -> void:
	_process_input(delta)
	_process_movement(delta)


func _process_input(delta: float) -> void:
	# Walking
	dir = Vector3()
	var cam_transform = world_camera.get_global_transform()
	
	var movement_input = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_forward") - Input.get_action_strength("move_back")
	).normalized()
	
	dir += -cam_transform.basis.z * movement_input.y
	dir += cam_transform.basis.x * movement_input.x
	
	# Jumping
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
	
	# Capture / free cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _process_movement(delta: float) -> void:
	dir.y = 0
	dir = dir.normalized()
	
	velocity.y -= delta * gravity
	
	var hvel = velocity
	hvel.y = 0
	
	var target = dir * SPEED
	
	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL
	
	hvel = hvel.lerp(target, accel * delta)
	velocity.x = hvel.x
	velocity.z = hvel.z
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg_to_rad(event.relative.y * mouse_sensitivity * -1))
		self.rotate_y(deg_to_rad(event.relative.x * mouse_sensitivity * -1))
		
		var camera_rot = rotation_helper.rotation
		camera_rot.x = clamp(camera_rot.x, -0.5*PI, 0.5*PI)
		rotation_helper.rotation = camera_rot
