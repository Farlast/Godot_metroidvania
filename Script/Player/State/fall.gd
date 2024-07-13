extends State
class_name Fall

var active_input : bool
var v_direction : float

var timer : float
var doublejump_timewindow : float = 0.5

func on_enter():
	super.on_enter()
	animator.play("fall")
	active_input = true
	timer = 0
	if player.is_on_floor():
		player.set_last_ground_position()

func on_exit():
	super.on_exit()
	active_input = false

func on_update(_delta : float):
	super.on_update(_delta)
	timer += _delta
	v_direction = Input.get_axis("move_down", "move_up")

func on_physics_update(_delta : float):
	super.on_physics_update(_delta)
	var direction = Input.get_axis("move_left", "move_right")
	if player.is_can_wall_grip() and direction != 0:
		transition.emit(self,"wallgrip")
	elif player.is_on_floor():
		player.footstep_player.play_land()
		if direction != 0 : 
			transition.emit(self,"run")
		else :
			transition.emit(self,"Idle")
	player.check_and_refill_doublejump()
	player.move_horizontal(player.walk_speed)
	player.add_fall_gravity(_delta)
	player.move_and_slide()


func _unhandled_input(event):
	if not is_controllable(): return
	if not active_input : return
	if event.is_action_pressed("jump"):
		player.check_jumpbuffer_time()
	elif event.is_action_pressed("jump") && player.Is_can_coyote_time:
		player.Is_can_coyote_time = false
		transition.emit(self,"jump")
	elif event.is_action_pressed("attack") && v_direction > 0:
		transition.emit(self,"attack_up")
	elif event.is_action_pressed("attack"):
		transition.emit(self,"air_attack_combo")
	elif event.is_action_pressed("dash") && player.is_can_dash():
		transition.emit(self,"dash")
	elif player.is_can_cast_skill(event):
		transition.emit(self,"performskill")
	glide_or_doublejump(event)

func glide_or_doublejump(event):
	if event.is_action_pressed("jump") and player.check_double_jump():
		player.Is_doublejump_used = true
		transition.emit(self,"jump")
	elif event.is_action_pressed("glide") and player.is_can_glide():
		transition.emit(self,"gliding")
	
