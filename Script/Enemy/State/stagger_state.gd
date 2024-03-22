extends EnemyState
class_name StaggerState

func on_enter():
	super.on_enter()
	agent.velocity = Vector2.ZERO
	animator.play("stagger")
	await get_tree().create_timer(agent.stagger_duration).timeout
	transition.emit(self,"idle")

func on_exit():
	super.on_exit()
	#agent.health_system.stance.add(agent.health_system.stance.max_value)

func on_update(_delta : float):
	super.on_update(_delta)

func on_physics_update(_delta : float):
	agent.add_drag(_delta,10)
	super.on_physics_update(_delta)
