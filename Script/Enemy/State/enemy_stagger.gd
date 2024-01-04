extends EnemyState
class_name enemy_stagger

func on_enter():
	super.on_enter()
	agent.velocity = Vector2.ZERO
	agent.velocity.x = 200 * -agent.get_hit_direction.x
	animator.play("hit")
	await get_tree().create_timer(agent.stagger_duration).timeout
	transition.emit(self,"idle")

func on_exit():
	super.on_exit()

func on_update(_delta : float):
	super.on_update(_delta)

func on_physics_update(_delta : float):
	if agent.velocity.x > 0:
		agent.velocity.x -= 200 * _delta
	elif agent.velocity.x < 0:
		agent.velocity.x += 200 * _delta
	super.on_physics_update(_delta)
