extends Enemy

@export var move_speed :float = 100
@export var turn_speed :float = 15

var snanp_vector : Vector2
var move_direction : Vector2 = Vector2.RIGHT
var target_rotation : float

func on_idle_enter(_state:EnemyState):
	target_rotation = move_direction.angle()
	pass

func on_idle(_state:EnemyState,_delta:float):
	pass

func on_idle_physics(_state:EnemyState,_delta:float):
	var coll = move_and_collide(move_direction * move_speed * _delta)
	lerp_rotation(_delta)
	if  coll != null:
		move_direction = coll.get_normal().rotated(PI/2)
		target_rotation = move_direction.angle()
		snanp_vector = coll.get_normal().rotated(PI)
	elif not is_on_floor():
		move_direction += snanp_vector.normalized()

func lerp_rotation(delta):
	rotation = lerp_angle(rotation,target_rotation,turn_speed * delta)
