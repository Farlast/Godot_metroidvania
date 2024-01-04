extends State
class_name Absorb

func on_enter():
	super.on_enter()
	animator.play("absorp")
	player.velocity = Vector2.ZERO
	await animator.animation_finished
	await get_tree().create_timer(0.15).timeout
	if player.is_on_floor():
		transition.emit(self,"idle")
	else:
		transition.emit(self,"fall")
func on_exit():
	super.on_exit()
	animator.play("RESET")

func on_update(_delta : float):
	pass

func on_physics_update(_delta : float):
	pass
