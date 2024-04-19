class_name Sprint extends Run

func _unhandled_input(event):
	if not is_controllable(): return
	if not active_input: return
	var h_direction = Input.get_axis("move_left", "move_right")
	if h_direction == 0:
		player.busy_duration = 0.3
		transition.emit(self,"busy")
	elif event.is_action_released("move_left") or event.is_action_released("move_right"):
		transition.emit(self,"idle")
	elif event.is_action_pressed("jump") && player.is_on_floor():
		transition.emit(self,"bulletjump")
	elif event.is_action_pressed("attack"):
		transition.emit(self,"chargeattack")
