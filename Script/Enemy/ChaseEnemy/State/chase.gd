extends EnemyState
class_name ChaseState

@export var down_ray : RayCast2D

func on_enter():
	animator.play("chase")

func on_update(_delta : float):
	if not agent.is_on_floor():return
	
	agent.face_to_target()
	var distance = abs(agent.target.global_position.x - agent.global_position.x)
	if distance > 1000:
		agent.target = null
		transition.emit(self,"idle")
	if distance < 200:
		if owner.has_method("on_in_attack_range"):
			owner.on_in_attack_range(self,_delta)
			return
	
	if agent.turn_left :
		agent.velocity.x = -1 * agent.move_speed
	else:
		agent.velocity.x = 1 * agent.move_speed
	
	if not down_ray.is_colliding():
		transition.emit(self,"idle")

func on_physics_update(_delta : float):
	super.on_physics_update(_delta)
