class_name HurtBox
extends Area2D

func _ready():
	#collision_layer = 0
	connect("area_entered",hurt)

func hurt(body : Area2D):
	var attackBox = body as AttackBox
	if attackBox == null : return
	if owner.has_method("take_damage"):
		attackBox.damage_data.sender_position = attackBox.global_position
		owner.take_damage(attackBox.damage_data)
