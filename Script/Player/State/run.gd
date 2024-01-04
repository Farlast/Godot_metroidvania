extends State
class_name Run

var active_input : bool
var position_update_time : float = 0.3
var position_update_timer : float

func on_enter():
	super.on_enter()
	animator.play("run")
	active_input = true
	player.update_area()
	position_update_timer = 0
	
func on_exit():
	super.on_exit()
	active_input = false
	player.update_area()
	
func on_update(_delta : float):
	super.on_update(_delta)
	if player.Is_can_bufferjump: 
		transition.emit(self,"Jump")
	if position_update_timer < position_update_time:
		position_update_timer += _delta
	else :
		player.set_last_ground_position()
		position_update_timer = 0

func on_physics_update(_delta : float):
	super.on_physics_update(_delta)
	if not player.is_on_floor():
		player.add_fall_gravity(_delta)
	if not player.is_on_floor() && player.velocity.y > 0:
		player.check_coyote_time()
		transition.emit(self,"fall")
	
	player.move_horizontal()
	player.move_and_slide()

func _unhandled_input(event):
	if not active_input: return
	var h_direction = Input.get_axis("move_left", "move_right")
	if h_direction == 0:
		transition.emit(self,"idle")
		return
	if event.is_action_released("move_left") or event.is_action_released("move_right"):
		transition.emit(self,"idle")
	elif event.is_action_pressed("jump") && player.is_on_floor():
		transition.emit(self,"Jump")
	elif event.is_action_pressed("attack") && player.Is_can_attack:
		transition.emit(self,"attack")
	elif event.is_action_pressed("absorp"):
		transition.emit(self,"absorb")
	elif player.player_data.is_dash_unlock && event.is_action_pressed("dash") && player.Is_can_dash:
		transition.emit(self,"dash")
