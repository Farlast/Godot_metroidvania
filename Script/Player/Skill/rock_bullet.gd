class_name RockBullet
extends Skill

@onready var bullet_scene : PackedScene = preload("res://Scenes/Effect/bullet_acid.tscn")

func active_skill():	
	var bullet_ins := bullet_scene.instantiate() as Bullet
	bullet_ins.position = position
	bullet_ins.direction = Vector2(direction.x,0)
	add_sibling.call_deferred(bullet_ins)
	bullet_ins.damage_data = damage_data
	bullet_ins.rotation = atan2(direction.x,0)
	bullet_ins.speed = speed
	queue_free()
