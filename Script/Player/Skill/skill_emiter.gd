class_name SkillEmiter
extends Node2D

@export var cost : float
@export var damage_data : DamageData
@export var speed : float = 800

@export var direction : Vector2
@export var sender : Node2D

###--constructor--
func SkillEmiter(_sender : Node2D ,start_position : Vector2, _direction : Vector2):
	global_position = start_position
	direction = _direction
	sender = _sender

func constructor(_sender : Node2D ,start_position : Vector2, _direction : Vector2):
	global_position = start_position
	direction = _direction
	sender = _sender

func active_skill():
	pass
