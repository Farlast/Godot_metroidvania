extends State
class_name Idle

var active_input : bool
var v_direction : float
var h_direction : float

func on_enter():
	super.on_enter()
	animator.play("idle")
	active_input = true
	player.update_area()
	player.velocity = Vector2.ZERO
	
func on_exit():
	super.on_exit()
	active_input = false

func on_update(_delta : float):
	super.on_update(_delta)
	if not player.is_on_floor():
		transition.emit(self,"fall")
	v_direction = Input.get_axis("move_down", "move_up")
	h_direction = Input.get_axis("move_left", "move_right")
	if player.Is_can_bufferjump:
		transition.emit(self,"Jump")
	elif v_direction < 0:
		transition.emit(self,"crouch")
	elif h_direction != 0:
		transition.emit(self,"Run")
	
func on_physics_update(_delta : float):
	super.on_physics_update(_delta)
	player.add_fall_gravity(_delta)
	player.move_and_slide()
	
func _unhandled_input(event):
	if not is_controllable(): return
	if not active_input: return
	player.update_area()
	if event.is_action_pressed("move_down"):
		transition.emit(self,"duck")
	
	if event.is_action_pressed("jump") && player.is_on_floor():
		transition.emit(self,"Jump")
	elif event.is_action_pressed("attack") && v_direction > 0:
		transition.emit(self,"attack_up")
	elif event.is_action_pressed("attack"):
		transition.emit(self,"chargeable_attack")
	elif event.is_action_pressed("dash") && player.is_can_dash():
		transition.emit(self,"dash")
	elif player.is_can_use_skill(event):
		transition.emit(self,"absorb")
	elif player.is_can_cast_skill(event):
		transition.emit(self,"performskill")
	elif player.is_can_heal(event):
		player.start_heal()
