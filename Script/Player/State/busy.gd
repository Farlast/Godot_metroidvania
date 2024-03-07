class_name Busy
extends State

func on_enter():
	super.on_enter()
	player.velocity = Vector2.ZERO
	await get_tree().create_timer(player.busy_duration).timeout
	if player.is_on_floor():
		transition.emit(self,"idle")
	else:
		transition.emit(self,"fall")

func on_exit():
	super.on_exit()

func on_physics_update(_delta : float):
	#player.add_fall_gravity(_delta)
	player.move_and_slide()
