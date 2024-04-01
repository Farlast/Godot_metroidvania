extends State
class_name Jump

var off_ground : bool
var active_input : bool
var v_direction : float

func on_enter():
	super.on_enter()
	player.velocity.y = player.jump_velocity
	off_ground = false
	animator.play("Jump")
	active_input = true
	if not Input.is_action_pressed("jump"):
		player.velocity.y += abs(player.velocity.y)/2
	if player.is_on_floor():
		player.set_last_ground_position()

func on_exit():
	super.on_exit()
	active_input = false

func on_update(_delta : float):
	super.on_update(_delta)
	v_direction = Input.get_axis("move_down", "move_up")

func on_physics_update(_delta : float):
	super.on_physics_update(_delta)
	if not player.is_on_floor():
		off_ground = true
		player.add_fall_gravity(_delta)
	elif player.is_on_floor() && off_ground:
		transition.emit(self,"Idle")
		
	if player.velocity.y > 0:
		transition.emit(self,"fall")
		return
	
	player.move_horizontal()
	player.move_and_slide()
		
func _unhandled_input(event):
	if not is_controllable(): return
	if not active_input : return
	player.update_area()
	if event.is_action_released("jump") && not player.is_on_floor():
		if player.velocity.y < 0:
			player.velocity.y += abs(player.velocity.y)
	elif event.is_action_pressed("attack") && v_direction > 0:
		transition.emit(self,"attack_up")
	elif event.is_action_pressed("attack"):
		transition.emit(self,"air_attack_combo")
	elif player.is_can_use_skill(event):
		transition.emit(self,"absorb")
	elif event.is_action_pressed("dash") && player.is_can_dash():
		transition.emit(self,"dash")
	elif player.is_can_cast_skill(event):
		transition.emit(self,"performskill")
