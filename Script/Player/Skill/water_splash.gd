class_name WaterSplash
extends Skill

@onready var bullet_scene : PackedScene = preload("res://Scenes/Effect/water_bullet.tscn")
@export var bullet_amount : float = 1
var fan_radius = 0.4

func active_skill():	
	for i in bullet_amount:
		var bullet_ins := bullet_scene.instantiate() as Bullet
		var angle = deg_to_rad(i * (300 / bullet_amount))
		var y = fan_radius * sin(angle)
		bullet_ins.position = position
		bullet_ins.direction = Vector2(direction.x,y)
		bullet_ins.damage_data = damage_data
		bullet_ins.rotation = atan2(direction.x,-y)
		bullet_ins.speed = speed
		add_sibling.call_deferred(bullet_ins)
		
	queue_free()
