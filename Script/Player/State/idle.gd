extends State
class_name Idle

var active_input : bool
var v_direction : float
var h_direction : float

func on_enter()->void:
	super.on_enter()
	animator.play("idle")
	active_input = true
	player.update_area()
	player.velocity = Vector2.ZERO
	h_direction = Input.get_axis("move_left", "move_right")
	
	if player.Is_can_bufferjump:
		transition.emit(self,"Jump")
	elif h_direction != 0:
		transition.emit(self,"Run")
	
func on_exit()->void:
	super.on_exit()
	active_input = false

func on_physics_update(_delta : float)->void:
	if not player.is_on_floor():
		transition.emit(self,"fall")
	super.on_physics_update(_delta)
	player.add_fall_gravity(_delta)
	player.move_and_slide()
	player.check_and_refill_doublejump()
	
func _unhandled_input(event:InputEvent)->void:
	if not is_controllable(): return
	if not active_input: return
	player.update_area()
	v_direction = Input.get_axis("move_down", "move_up")
	h_direction = Input.get_axis("move_left", "move_right")
	
	if h_direction != 0:
		transition.emit(self,"Run")
	elif v_direction < 0 and (event.is_action_pressed("jump") or player.Is_can_bufferjump):
		player.position.y += 1
	elif event.is_action_pressed("jump") && player.is_on_floor():
		transition.emit(self,"Jump")
	elif event.is_action_pressed("attack") && v_direction > 0:
		transition.emit(self,"attack_up")
	elif event.is_action_pressed("attack"):
		transition.emit(self,"chargeable_attack")
	elif event.is_action_pressed("dash") && player.is_can_dash():
		transition.emit(self,"dash")
	elif player.skill_system.is_projectile_ready(event):
		transition.emit(self,"projectile")
	elif player.skill_system.is_familiar_ready(event):
		transition.emit(self,"performskill")
	elif player.is_can_heal(event):
		player.start_heal()
