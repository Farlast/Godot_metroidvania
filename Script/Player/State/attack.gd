extends State
class_name Attack

@export var attack_audio : AudioStreamPlayer2D
var active_input : bool
var old_direction : float
var direction

func on_enter():
	super.on_enter()
	active_input = true
	animator.play("attack")
	player.update_area()
	direction = Input.get_axis("move_left", "move_right")
	old_direction = direction
	player.velocity.x = direction * player.walk_speed
	if attack_audio:
		attack_audio.play()
	await animator.animation_finished
	
	if player.is_on_floor() : 
		transition.emit(self,"Idle")
	else :
		transition.emit(self,"fall")
	
	
func on_exit():
	super.on_exit()
	active_input = false
	animator.play("RESET")
	player.get_hit_direction = Vector2.ZERO
	player.attack_cooldown()
	
func on_update(_delta : float):
	super.on_update(_delta)

func on_physics_update(_delta : float):
	super.on_physics_update(_delta)
	player.add_fall_gravity(_delta)
	player.move_and_slide()
	
func  _unhandled_input(event):
	if not active_input: return
	if event.is_action_released("move_left") || event.is_action_released("move_right"):
		player.velocity = Vector2.ZERO
