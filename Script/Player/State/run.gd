extends State
class_name Run

@export var run_speed :float = 500.0
@export var animation_name :String = "run"

var active_input : bool
var position_update_time : float = 0.3
var position_update_timer : float

func on_enter():
	super.on_enter()
	animator.play(animation_name)
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
	
	player.move_horizontal(run_speed)
	player.move_and_slide()

func _unhandled_input(event):
	if not is_controllable(): return
	if not active_input: return
	var h_direction = Input.get_axis("move_left", "move_right")
	if h_direction == 0:
		transition.emit(self,"idle")
	elif event.is_action_pressed("jump") && player.is_on_floor():
		transition.emit(self,"Jump")
	elif event.is_action_pressed("attack"):
		transition.emit(self,"chargeable_attack")
	elif player.is_can_use_skill(event):
		transition.emit(self,"absorb")
	elif event.is_action_pressed("dash") && player.is_can_dash():
		transition.emit(self,"dash")
	elif player.is_can_cast_skill(event):
		transition.emit(self,"performskill")
	elif player.is_can_heal(event):
		player.start_heal()
