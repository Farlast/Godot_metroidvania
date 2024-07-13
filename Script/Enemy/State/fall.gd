class_name EnemyFall extends EnemyState

func on_enter():
	super.on_enter()
	agent.velocity = Vector2.ZERO

func on_exit():
	super.on_exit()

func on_update(_delta : float):
	super.on_update(_delta)
	agent.add_gravity(_delta)
	if agent.is_on_floor():
		transition.emit(self,"idle")
