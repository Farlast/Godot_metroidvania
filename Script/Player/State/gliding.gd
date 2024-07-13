class_name Gliding extends State

var active_input : bool
var h_direction : float

func on_enter():
	super.on_enter()
	animator.play("fall")
	active_input = true
	player.velocity.y = 100

func on_exit():
	super.on_exit()
	active_input = false

func _unhandled_input(event):
	if not is_controllable(): return
	if not active_input : return
	if event.is_action_released("glide"):
		transition.emit(self,"fall")

func on_update(_delta : float):
	super.on_update(_delta)
	h_direction = Input.get_axis("move_left", "move_right")

func on_physics_update(_delta : float):
	super.on_physics_update(_delta)
	if player.is_can_wall_grip() and h_direction != 0:
		transition.emit(self,"wallgrip")
	elif player.is_on_floor():
		player.footstep_player.play_land()
		transition.emit(self,"Idle")
	
	player.check_and_refill_doublejump()
	player.move_horizontal(player.walk_speed)
	fall(_delta)
	player.move_and_slide()

func fall(delta):
	if player.external_velocity != Vector2.ZERO:
		player.velocity += player.external_velocity * delta
	else:
		player.velocity.y += 450 * delta
	player.velocity.y = clampf(player.velocity.y,-500,450)
