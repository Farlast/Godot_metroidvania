class_name HurtBox
extends Area2D

@export var object_tag : AttackReport.ObjectTag

func _ready():
	connect("area_entered",hurt)

func set_collition_layer(index : int):
	# Decimal - Add the results of 2 to the power of (layer to be enabled - 1).
	collision_layer = floor(pow(2, index-1))

func hurt(body : Area2D):
	if not body is AttackBox: return
	
	var attack_box = body as AttackBox
	if owner.has_method("take_damage"):
		var damage_data :DamageData = attack_box.get_damage_data()
		## protect damage self
		if damage_data.attacker_id == owner.get_instance_id(): return
		var is_attack_success = await owner.take_damage(damage_data)
		if is_attack_success == null: is_attack_success = false
		
		## send report back to attacker
		var report := AttackReport.new()	
		report.set_data(is_attack_success,object_tag,damage_data,global_position)
		if is_instance_valid(attack_box):
			attack_box.attack_feedback(report)

