class_name Busy
extends State

func on_enter()->void:
	super.on_enter()
	await get_tree().create_timer(player.busy_duration).timeout
	if player.is_on_floor():
		transition.emit(self,"idle")
	else:
		transition.emit(self,"fall")

func on_exit()->void:
	super.on_exit()

func on_physics_update(_delta : float)->void:
	player.add_fall_gravity(_delta)
	player.add_drag(_delta)
	player.move_and_slide()
