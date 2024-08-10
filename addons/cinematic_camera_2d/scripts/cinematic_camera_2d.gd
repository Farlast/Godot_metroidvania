@icon("res://addons/cinematic_camera_2d/icons/cinematic_camera_2d.svg")
class_name CinematicCamera2D
extends Camera2D

## Cinematic camera node for 2D scenes.
## Uses a VirtualCamera2D to create transitions between cameras.

@export var is_main: bool = true
## The node that this camera is supposed to follow.
## The camera's global position will be set to this node's global position every frame.
@export var follow_node: Node2D = null
## The current virtual camera node. A scene may have several virtual cameras, but only needs one
## cinematic camera. Update this value to transition between different cameras.
@export var virtual_camera: VirtualCamera2D = null
## The speed at which the transitions take place. Used by zoom and offset.
@export var transition_speed: float = 1.0

@export_group("Shake")
@export var decay := 0.8 #How quickly shaking will stop [0,1].
@export var max_offset := Vector2(100,75) #Maximum displacement in pixels.
@export var max_roll := 0.1 #Maximum rotation in radians (use sparingly).
@export var noise : FastNoiseLite #The source of random values.

var noise_y = 0 #Value used to move through the noise
var trauma := 0.0 #Current shake strength
var trauma_pwr := 2 #Trauma exponent. Use [2,3]

func _ready():
	noise = FastNoiseLite.new()
	if is_main : GameManager.main_camera = self

func _process(delta: float) -> void:
	# Update the camera if a virtual camera was assigned
	if is_instance_valid(virtual_camera):
		# Update zoom and offset
		zoom = zoom.move_toward(virtual_camera.zoom, delta * max(0.0, transition_speed))
		offset = offset.move_toward(virtual_camera.offset, delta * max(0.0, transition_speed))
		# Clamp camera position within bounds
		var half_bounds := get_viewport_rect().size / zoom / 2.0
		var top_left := Vector2(virtual_camera.limit_left, virtual_camera.limit_top)
		var bottom_right := Vector2(virtual_camera.limit_right, virtual_camera.limit_bottom)
		top_left += virtual_camera.global_position + half_bounds - offset
		bottom_right += virtual_camera.global_position - half_bounds - offset
		# Follow the follow node if assigned
		if is_instance_valid(follow_node):
			global_position = follow_node.global_position.clamp(top_left, bottom_right)
		# Use camera position if no follow node is assigned
		else:
			global_position = global_position.clamp(top_left, bottom_right)
	# Use the same position as the follow node if no virtual camera is assigned
	elif is_instance_valid(follow_node):
		global_position = follow_node.global_position
	
	#shaking
	if trauma > 0:
		trauma = max(trauma - decay * delta, 0)
		shake()
	
#region Shake

func add_trauma(amount : float):
	trauma = min(trauma + amount, 1.0)

func add_clamp_trauma(amount : float):
	if trauma < amount:
		trauma = min(trauma + amount, 1.0)

func shake(): 
	var amt = pow(trauma, trauma_pwr)
	noise_y += 1
	rotation = max_roll * amt * noise.get_noise_2d(noise.seed,noise_y)
	offset.x = max_offset.x * amt * noise.get_noise_2d(noise.seed*2,noise_y)
	offset.y = max_offset.y * amt * noise.get_noise_2d(noise.seed*3,noise_y)
#endregion
