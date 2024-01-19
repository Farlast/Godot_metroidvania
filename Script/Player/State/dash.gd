extends State
class_name Dash

@export var dash_duration : float = 0.5
@export var dash_speed : float = 500
@export var dash_effect : GPUParticles2D

var dash_timer : float
var direction : int

func on_enter():
	super.on_enter()
	animator.play("dash")
	dash_effect.emitting = true
	dash_timer = 0
	player.velocity = Vector2.ZERO
	if player.player_sprite.flip_h:
		direction = -1
	else:
		direction = 1
	

func on_exit():
	super.on_exit()
	player.dash_cooldown()

func on_update(_delta : float):
	super.on_update(_delta)
	dash_timer += _delta
	if dash_timer < dash_duration: return
	if not player.is_on_floor():
		transition.emit(self,"fall")
		return
	var input_direction = Input.get_axis("move_left", "move_right")
	if input_direction == 0:
		transition.emit(self,"idle")
	else:
		transition.emit(self,"run")

func on_physics_update(_delta : float):
	super.on_physics_update(_delta)
	player.velocity.x = direction * dash_speed
	player.move_and_slide()
