extends Enemy
class_name PatrolEnemy

@export_category("Movement")
@export var move_speed : float = 60
@export var turn_left : bool = true

@onready var down_ray : RayCast2D = $Directions/DownRay
@onready var fornt_ray : RayCast2D = $Directions/FrontRay

func on_idle(_state:EnemyState):
	
	if is_on_floor():
		if not down_ray.is_colliding() or fornt_ray.is_colliding():
			flip_direction()
	
	if is_on_floor():
		if turn_left :
			velocity.x = -1 * move_speed
		else:
			velocity.x = 1 * move_speed
	
	move_and_slide()

func _process(delta):
	add_gravity(delta)

func flip_direction():
	turn_left = ! turn_left
	super.flip_direction()
	
