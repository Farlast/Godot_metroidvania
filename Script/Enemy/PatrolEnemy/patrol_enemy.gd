extends Enemy
class_name PatrolEnemy

@export_category("Movement")
@export var move_speed : float = 60
@export var turn_left : bool = true

@onready var down_ray : RayCast2D = $Direction/DownRay
@onready var fornt_ray : RayCast2D = $Direction/FrontRay

func flip_direction():
	turn_left = ! turn_left
	super.flip_direction()
	
func take_damage(damage_data : DamageData)->bool:
	## add knockback
	velocity.x = (move_speed * 1.5) * -get_hit_direction.x
	return super.take_damage(damage_data)
