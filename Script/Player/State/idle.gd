extends State
class_name Idle

var active_input : bool

func on_enter():
	super.on_enter()
	animator.play("idle")
	active_input = true
	player.update_area()
	
	
func on_exit():
	super.on_exit()
	active_input = false

func on_update(_delta : float):
	super.on_update(_delta)
	var v_direction = Input.get_axis("move_down", "move_up")
	var h_direction = Input.get_axis("move_left", "move_right")
	if player.Is_can_bufferjump:
		transition.emit(self,"Jump")
	elif v_direction < 0:
		transition.emit(self,"duck")
	elif h_direction != 0:
		transition.emit(self,"Run")
	
func on_physics_update(_delta : float):
	super.on_physics_update(_delta)
	if player.is_on_floor():
		if player.velocity.x > 0:
			player.velocity.x -= abs(player.velocity.x)
		else:
			player.velocity.x += abs(player.velocity.x)
	player.add_fall_gravity(_delta)
	player.move_and_slide()
	
func _unhandled_input(event):
	if not active_input: return
	player.update_area()
	if event.is_action_pressed("move_down") && player.is_on_floor():
		transition.emit(self,"duck")
	if event.is_action_pressed("jump") && player.is_on_floor():
		transition.emit(self,"Jump")
	elif event.is_action_pressed("attack") && player.Is_can_attack:
		transition.emit(self,"attack")
	elif player.is_can_use_skill(event):
		transition.emit(self,"absorb")
	elif player.player_data.is_dash_unlock && event.is_action_pressed("dash") && player.is_can_dash():
		transition.emit(self,"dash")
	elif player.is_can_cast_skill(event):
		player.set_cast_state()
