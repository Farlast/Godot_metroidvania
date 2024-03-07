class_name AttackReport
extends Resource

enum ObjectTag {OBJECT,ENEMY,PLAYER}

var success :bool
var object_tag :ObjectTag
var damage_data :DamageData
var receiver_position : Vector2

func set_data(_success:bool,_object_tag:ObjectTag,_damage_data:DamageData,_receiver_position:Vector2):
	success = _success
	object_tag = _object_tag
	damage_data = _damage_data
	receiver_position = _receiver_position
