class_name PatrolState
extends EnemyState

@onready var down_ray : RayCast2D = $"../../Direction/DownRay"
@onready var fornt_ray : RayCast2D = $"../../Direction/FrontRay"

func on_enter()->void:
	super.on_enter()
	animator.play("move")

func on_exit()->void:
	super.on_exit()

func on_update(_delta : float)->void:
	super.on_update(_delta)
	if agent.is_on_floor():
		if not down_ray.is_colliding() or fornt_ray.is_colliding():
			agent.flip_direction()	
		if agent.turn_left :
			agent.velocity.x = -1 * agent.move_speed
		else:
			agent.velocity.x = 1 * agent.move_speed

func on_physics_update(_delta : float)->void:
	if agent.velocity.x > 0:
		agent.velocity.x -= 200 * _delta
	elif agent.velocity.x < 0:
		agent.velocity.x += 200 * _delta
	super.on_physics_update(_delta)
