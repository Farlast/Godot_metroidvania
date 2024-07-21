extends EnemyState
class_name ChaseState

@onready var down_ray : RayCast2D = $"../../Direction/DownRay"
@export var min_attack_range : float = 100
@export var max_attack_range : float = 300
@export var stop_follow_range : float = 1000
@export var next_state : EnemyState

var attack_range : float

func on_enter()->void:
	animator.play("chase")
	attack_range = randf_range(min_attack_range,max_attack_range)

func on_update(_delta : float)->void:
	if not agent.is_on_floor():return
	
	agent.face_to_target()
	var distance :float = abs(agent.target.global_position.x - agent.global_position.x)
	if distance > stop_follow_range:
		agent.target = null
		transition.emit(self,"idle")
	if distance < attack_range:
		if owner.has_method("on_in_attack_range"):
			owner.on_in_attack_range(self,_delta)
			return
		else:
			transition.emit(self,next_state.name)
			return
	
	if not down_ray.is_colliding():
		agent.velocity.x = 0
		agent.target = null
		transition.emit(self,"idle")
	elif agent.turn_left :
		agent.velocity.x = -1 * agent.move_speed
	else:
		agent.velocity.x = 1 * agent.move_speed

func on_physics_update(_delta : float)->void:
	super.on_physics_update(_delta)
