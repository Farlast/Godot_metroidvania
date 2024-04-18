class_name SingleBullet
extends SkillContainer

@export var direction : Vector2
@export var speed : float = 800
@export var damage_data : DamageData

func active_skill(skill_system : SkillSystem):
	direction = skill_system.player.direction_holder.scale
	var bullet_ins := get_scene_async().instantiate() as Bullet
	bullet_ins.position = skill_system.player.front_point.global_position
	bullet_ins.direction = Vector2(direction.x,0)
	skill_system.player.add_sibling.call_deferred(bullet_ins)
	bullet_ins.damage_data = damage_data
	bullet_ins.rotation = atan2(direction.x,0)
	bullet_ins.speed = speed
