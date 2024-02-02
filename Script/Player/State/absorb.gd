extends State
class_name Absorb

var active_input : bool

func on_enter():
	super.on_enter()
	active_input = true
	animator.play("sample")
	player.skill_system.skill_sample()
	await animator.animation_finished
	if player.is_on_floor():
		transition.emit(self,"idle")
	else:
		transition.emit(self,"fall")

func on_exit():
	super.on_exit()
	active_input = false

func on_update(_delta : float):
	pass

func on_physics_update(_delta : float):
	player.add_fall_gravity(_delta)
	player.move_and_slide()

func  _unhandled_input(event):
	if not active_input: return
	if event.is_action_released("move_left") || event.is_action_released("move_right"):
		player.velocity = Vector2.ZERO
