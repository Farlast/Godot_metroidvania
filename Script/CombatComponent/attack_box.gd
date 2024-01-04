class_name AttackBox
extends Area2D

@export var damage_data : DamageData

func _ready():
	#collision_mask = 0
	damage_data.sender_position = global_position
	connect("area_entered",attack_feedback)

func attack_feedback(body : Area2D):
	var hurtBox = body as HurtBox
	if hurtBox == null : return
	if owner.has_method("attack_feedback"):
		owner.attack_feedback(hurtBox)
