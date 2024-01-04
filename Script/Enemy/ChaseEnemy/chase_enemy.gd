extends Enemy
class_name ChaseEnemy

@export_category("Movement")
@export var move_speed : float = 200
@export var turn_left : bool = true

@onready var down_ray : RayCast2D = $Directions/GroundRay
@onready var front_ray : RayCast2D = $Directions/FrontRay

var target : Node2D

func _ready():
	if turn_left:
		direction_holder.scale.x = abs(direction_holder.scale.x)
	else:
		direction_holder.scale.x = -abs(direction_holder.scale.x)

func take_damage(damage_data : DamageData):
	super.take_damage(damage_data)
	if target != null:return
	if turn_left:
		turn_left = false		
		direction_holder.scale.x = -abs(direction_holder.scale.x)
	else:
		turn_left = true		
		direction_holder.scale.x = abs(direction_holder.scale.x)
	
func on_idle(state : EnemyState):
	if not is_on_floor():return
	
	if front_ray.is_colliding():
		target = front_ray.get_collider() as Node2D
		state.transition.emit(state,"chase")
	
func on_chase(state : EnemyState,_delta : float):
	if not is_on_floor():return
	
	face_to_target()
	
	var distance = target.global_position.x - global_position.x
	if abs(distance) > 1000:
		target = null
		state.transition.emit(state,"idle")
	
	if turn_left :
		velocity.x = -1 * move_speed
	else:
		velocity.x = 1 * move_speed
	
	if not down_ray.is_colliding():
		state.transition.emit(state,"idle")
	
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
