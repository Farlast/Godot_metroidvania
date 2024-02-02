class_name WaterJet
extends Skill

@onready var bullet_scene : PackedScene = preload("res://Scenes/Effect/bullet_acid.tscn")
@export var bullet_amount : float = 3 
var fan_radius = 0.3

func active_skill():	
	for i in bullet_amount:
		var bullet_ins := bullet_scene.instantiate() as Bullet
		var angle = deg_to_rad(i * (360 / bullet_amount))
		var y = fan_radius * sin(angle)
		bullet_ins.position = position
		bullet_ins.direction = Vector2(direction.x,y)
		bullet_ins.attack_mask = DamageData.DamageMask.ENEMY
		bullet_ins.rotation = atan2(direction.x,-y)
		add_sibling.call_deferred(bullet_ins)
		
	queue_free()
