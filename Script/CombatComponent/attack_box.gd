class_name AttackBox
extends Area2D

@export var damage_data : DamageData

func _ready():
	damage_data.sender_position = global_position
	connect("area_entered",attack_feedback)

func set_collition_mask(index : int):
	# Decimal - Add the results of 2 to the power of (layer to be enabled - 1).
	collision_mask = floor(pow(2, index-1))

func attack_feedback(body : Area2D):
	var hurtBox = body as HurtBox
	if hurtBox == null : return
	if owner.has_method("attack_feedback"):
		owner.attack_feedback(hurtBox)
