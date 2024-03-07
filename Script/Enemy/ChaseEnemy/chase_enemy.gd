extends Enemy
class_name ChaseEnemy

@export_category("Movement")
@export var move_speed : float = 200
@export var turn_left : bool = true

@onready var front_ray : RayCast2D = $Direction/FrontRay

var target : Node2D

func _ready():
	super._ready()
	
	if direction_holder.scale.x > 0:
		turn_left = true
	else:
		turn_left = false

func take_damage(damage_data : DamageData)->bool:
	super.take_damage(damage_data)
	if target == null:
		if turn_left:
			turn_left = false		
			direction_holder.scale.x = -abs(direction_holder.scale.x)
		else:
			turn_left = true		
			direction_holder.scale.x = abs(direction_holder.scale.x)
	return true

func on_idle(state : EnemyState):
	if not is_on_floor():return
	
	if front_ray.is_colliding():
		target = front_ray.get_collider() as Node2D
		state.transition.emit(state,"chase")
	elif target != null:
		state.transition.emit(state,"chase")

func on_in_attack_range(state : EnemyState,_delta : float):
	state.transition.emit(state,"rampattack")
	
func face_to_target():
	if target == null: return
	if target.global_position.x > global_position.x:
		await get_tree().create_timer(0.3).timeout
		turn_left = false
		direction_holder.scale.x = -abs(direction_holder.scale.x)
	else:
		await get_tree().create_timer(0.3).timeout
		turn_left = true
		direction_holder.scale.x = abs(direction_holder.scale.x)
