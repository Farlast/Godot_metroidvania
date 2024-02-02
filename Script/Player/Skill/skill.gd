class_name Skill
extends Node2D

@export var damage_data : DamageData

var direction : Vector2

func constructor(_direction : Vector2):
	direction = _direction

func active_skill():
	pass
