class_name Fireball
extends Skill

@export_file("*.tscn") var bullet_path : String
@onready var bullet_scene : PackedScene = load(bullet_path)


func active_skill():	
	var bullet_ins := bullet_scene.instantiate() as Bullet
	bullet_ins.position = position
	bullet_ins.direction = Vector2(direction.x,0)
	add_sibling.call_deferred(bullet_ins)
	bullet_ins.damage_data = damage_data
	bullet_ins.rotation = atan2(direction.x,0)
	bullet_ins.speed = speed
	queue_free()
