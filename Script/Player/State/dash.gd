extends State
class_name Dash

@export var dash_duration : float = 0.5
@export var dash_speed : float = 500
@export var dash_effect : GPUParticles2D
@export var curve : Curve
@export var dashsound : AudioStream

var dash_timer : float
var direction : int
var active_input : bool

func on_enter():
	super.on_enter()
	if not player.is_on_floor():
		player.is_airdash_used = true
	GameManager.audio_player.play(dashsound,player.global_position)
	dash_effect.emitting = true
	dash_timer = 0
	active_input = true
	animator.play("dash")
	
	direction = ceil(Input.get_axis("move_left", "move_right"))
	if direction == 0:
		if player.player_sprite.flip_h:
			direction = -1
		else:
			direction = 1
	player.flip_sprite(direction)
	#player.velocity.x = direction * dash_speed
	
func on_exit():
	super.on_exit()
	player.dash_cooldown()
	active_input = false

func on_update(_delta : float):
	super.on_update(_delta)
	dash_timer += _delta
	if dash_timer < dash_duration: return
	next_stage()

func on_physics_update(_delta : float):
	super.on_physics_update(_delta)
	player.velocity = Vector2((curve.sample(dash_timer/dash_duration)*dash_speed)*direction ,0)
	player.move_and_slide()

func next_stage():
	if not player.is_on_floor():
		transition.emit(self,"fall")
	else:
		var h_direction = Input.get_axis("move_left", "move_right")
		if h_direction == 0:
			transition.emit(self,"idle")
		elif Input.is_action_pressed("dash"):
			transition.emit(self,"sprint")
		else:
			transition.emit(self,"run")
