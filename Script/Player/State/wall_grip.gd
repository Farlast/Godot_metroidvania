class_name WallGrip extends State

@export var effect : GPUParticles2D 
@export var jump_effect : GPUParticles2D
@export var slide_rate : float = 10
var active_input : bool

func on_enter():
	super.on_enter()
	player.velocity = Vector2(0,250)
	active_input = true
	player.dash_refill()
	animator.play("wall_slide")
	effect.emitting = true

func on_exit():
	super.on_exit()
	active_input = false
	effect.emitting = false

func on_update(_delta : float):
	super.on_update(_delta)

func on_physics_update(_delta : float):
	super.on_physics_update(_delta)
	if player.is_on_floor():
		transition.emit(self,"idle")
	if not player.wall_ray.is_colliding():
		transition.emit(self,"fall")
	player.move_and_slide()

func _unhandled_input(event):
	if not is_controllable(): return
	if not active_input: return
	var h_direction = Input.get_axis("move_left", "move_right")
	if h_direction == 0:
		transition.emit(self,"fall")
	if event.is_action_pressed("jump"):
		jump_effect.restart()
		player.flip_sprite(-player.direction_holder.scale.x)
		player.velocity.x = 200 * player.direction_holder.scale.x
		transition.emit(self,"bulletjump")
