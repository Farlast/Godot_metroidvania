class_name SplashBullet
extends SkillContainer

@export var bullet_amount : float = 1
@export var direction : Vector2
@export var speed : float = 800
@export var damage_data : DamageData
@export var fan_radius = 0.4

func active_skill(skill_system:SkillSystem):
	direction = skill_system.player.direction_holder.scale
	for i in bullet_amount:
		var bullet_ins :Bullet = get_scene_async().instantiate() as Bullet
		var angle = deg_to_rad(i * (300 / bullet_amount))
		var y = fan_radius * sin(angle)
		bullet_ins.position = skill_system.player.front_point.global_position
		bullet_ins.direction = Vector2(direction.x,y)
		bullet_ins.damage_data = damage_data
		bullet_ins.rotation = atan2(direction.x,-y)
		bullet_ins.speed = speed
		skill_system.player.add_sibling.call_deferred(bullet_ins)
