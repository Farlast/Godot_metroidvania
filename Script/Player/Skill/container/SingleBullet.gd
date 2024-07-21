class_name SingleBullet
extends SkillContainer

@export var speed : float = 800
@export var damage_data : DamageData

func fire_bullet(spawn_point : Node2D,direction : Vector2,parent_node:Node)->void:
	var bullet_ins := get_scene_async().instantiate() as Bullet
	bullet_ins.direction = direction
	bullet_ins.rotation = atan2(direction.x,-direction.y)
	bullet_ins.position = spawn_point.global_position
	bullet_ins.damage_data = damage_data
	bullet_ins.speed = speed
	parent_node.add_sibling.call_deferred(bullet_ins)

