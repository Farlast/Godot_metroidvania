extends EnemyState
class_name EnemyIdle


func on_enter():
	super.on_enter()
	animator.play("idle")
	
func on_exit():
	super.on_exit()

func on_update(_delta : float):
	super.on_update(_delta)
	if owner.has_method("on_idle"):
		owner.on_idle(self)

func on_physics_update(_delta : float):
	if agent.velocity.x > 0:
		agent.velocity.x -= 200 * _delta
	elif agent.velocity.x < 0:
		agent.velocity.x += 200 * _delta
	super.on_physics_update(_delta)
