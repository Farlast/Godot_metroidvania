class_name Skill
extends Resource

@export var cost : float
@export var cast_time : float
@export var damage_data : DamageData

var player : Player

func _init(_player : Player):
	player = _player

func active_skill():
	pass
