class_name HurtBox
extends Area2D

func _ready():
	connect("area_entered",hurt)

func set_collition_layer(index : int):
	# Decimal - Add the results of 2 to the power of (layer to be enabled - 1).
	collision_layer = floor(pow(2, index-1))

func hurt(body : Area2D):
	if not body is AttackBox: return
	var attackBox = body as AttackBox
	
	match attackBox.damage_data.take_damage_mask:
		DamageData.DamageMask.PLAYER:
			if owner is Enemy:
				return
		DamageData.DamageMask.ENEMY:
			if owner is Player:
				return
		
	if owner.has_method("take_damage"):
		attackBox.damage_data.sender_position = attackBox.global_position
		owner.take_damage(attackBox.damage_data)
