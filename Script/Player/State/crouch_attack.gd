extends State
class_name CrouchAttack

@export var attack_audio : AudioStreamPlayer2D
var active_input : bool

func on_enter():
	super.on_enter()
	active_input = true
	animator.play("crouch_attack_water")
	if attack_audio:
		attack_audio.play()
	await animator.animation_finished
	var direction = Input.get_axis("move_down", "move_up")
	if direction < 0:
		transition.emit(self,"duck")
	else:
		transition.emit(self,"idle")
	
func on_update(_delta : float):
	super.on_update(_delta)

func on_physics_update(_delta : float):
	super.on_physics_update(_delta)
	player.add_fall_gravity(_delta)
	player.move_and_slide()
	if not player.is_on_floor():
		transition.emit(self,"fall")

func on_exit():
	super.on_exit()
	active_input = false
	player.velocity = Vector2.ZERO

	
