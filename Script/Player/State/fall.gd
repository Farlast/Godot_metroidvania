extends State
class_name Fall

var active_input : bool

func on_enter():
	super.on_enter()
	animator.play("fall")
	active_input = true
	if player.is_on_floor():
		player.set_last_ground_position()

func on_exit():
	super.on_exit()
	active_input = false

func on_update(_delta : float):
	super.on_update(_delta)

func on_physics_update(_delta : float):
	super.on_physics_update(_delta)
	player.add_fall_gravity(_delta)
	if player.is_on_floor():
		var direction = Input.get_axis("move_left", "move_right")
		if direction != 0 : 
			transition.emit(self,"run")
		else :
			transition.emit(self,"Idle")
		return
	player.move_horizontal()
	player.move_and_slide()
	
func _unhandled_input(event):
	if not active_input : return
	if event.is_action_pressed("jump"):
		player.check_jumpbuffer_time()
	if event.is_action_pressed("attack") && player.Is_can_attack:
		transition.emit(self,"attack")
	elif event.is_action_pressed("jump") && player.Is_can_coyote_time:
		player.Is_can_coyote_time = false
		transition.emit(self,"jump")
	elif player.player_data.is_doublejump_unlock && event.is_action_pressed("jump") && not player.Is_doublejump_used && not player.is_on_floor():
		player.Is_doublejump_used = true
		transition.emit(self,"jump")
	elif player.is_can_use_skill(event):
		transition.emit(self,"absorb")
	elif player.player_data.is_dash_unlock && event.is_action_pressed("dash") && player.is_can_dash():
		transition.emit(self,"dash")
	elif player.is_can_cast_skill(event):
		player.set_cast_state()
