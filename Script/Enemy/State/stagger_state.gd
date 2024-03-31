extends EnemyState
class_name StaggerState

@export var stagger_duration : float = 0.3
var timer : float

func on_enter():
	super.on_enter()
	timer = 0
	agent.velocity = Vector2.ZERO
	animator.play("stagger")

func on_exit():
	super.on_exit()
	timer = 0

func on_update(_delta : float):
	super.on_update(_delta)
	timer += _delta
	if timer > stagger_duration:
		transition.emit(self,"idle")

func on_physics_update(_delta : float):
	agent.add_drag(_delta,10)
	super.on_physics_update(_delta)
