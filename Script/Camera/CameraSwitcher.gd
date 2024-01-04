extends Area2D

enum PathMode {HORIZONTAL,VERTICAL}
@export var mode : PathMode
@export var cinematic_camera: CinematicCamera2D
@export var virtual_camera_1: VirtualCamera2D
@export var virtual_camera_2: VirtualCamera2D
@export var transition_speed : float = 0.5

func _ready():
	connect("body_entered",_on_enter)
	connect("body_exited",_on_exit)

func _on_enter(_body : Node2D):
	cinematic_camera.transition_speed = transition_speed
	cinematic_camera.position_smoothing_enabled = true
	match mode:
		PathMode.HORIZONTAL:
			on_horizontal_mode(_body.global_position)
		PathMode.VERTICAL:
			on_vertical_mode(_body.global_position)

func _on_exit(_body : Node2D):
	match mode:
		PathMode.HORIZONTAL:
			on_exit_horizontal_mode(_body.global_position)
		PathMode.VERTICAL:
			on_exit_vertical_mode(_body.global_position)

func on_horizontal_mode(body_position : Vector2):
	if body_position.x > global_position.x:
		cinematic_camera.virtual_camera = virtual_camera_1
	else:
		cinematic_camera.virtual_camera = virtual_camera_2

func on_vertical_mode(body_position : Vector2):
	if body_position.y < global_position.y:
		cinematic_camera.virtual_camera = virtual_camera_1
	else:
		cinematic_camera.virtual_camera = virtual_camera_2

func on_exit_horizontal_mode(body_position : Vector2):
	if body_position.x < global_position.x:
		cinematic_camera.virtual_camera = virtual_camera_1
	else:
		cinematic_camera.virtual_camera = virtual_camera_2
	
func on_exit_vertical_mode(body_position : Vector2):
	if body_position.y < global_position.y:
		cinematic_camera.virtual_camera = virtual_camera_1
	else:
		cinematic_camera.virtual_camera = virtual_camera_2
