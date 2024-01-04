extends State
class_name Jump

var off_ground : bool
var active_input : bool

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

func on_physics_update(_delta : float):
	super.on_physics_update(_delta)
	if not player.is_on_floor() :
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
	if not active_input : return
	if event.is_action_released("jump") && not player.is_on_floor():
		if player.velocity.y < 0:
			player.velocity.y += abs(player.velocity.y)
	elif event.is_action_pressed("attack") && player.Is_can_attack:
		transition.emit(self,"attack")
	elif event.is_action_pressed("absorp"):
		transition.emit(self,"absorb")
	elif player.player_data.is_dash_unlock && event.is_action_pressed("dash") && player.Is_can_dash:
		transition.emit(self,"dash")
