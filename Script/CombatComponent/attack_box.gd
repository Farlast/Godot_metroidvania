class_name AttackBox
extends Area2D

@export var damage_data : DamageData

func set_collition_mask(index : int)->void:
	# Decimal - Add the results of 2 to the power of (layer to be enabled - 1).
	collision_mask = floor(pow(2, index-1))

func get_damage_data() -> DamageData:
	damage_data.sender_position = global_position
	damage_data.attacker_id = owner.get_instance_id()
	return damage_data

func attack_feedback(report : AttackReport)->void:
	if owner.has_method("attack_feedback"):
		owner.attack_feedback(report)
