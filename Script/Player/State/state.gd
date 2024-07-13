extends Node
class_name State

signal transition(state : State , new_state_name : String)

var animator : AnimationPlayer
var player : Player

func _ready()->void:
	animator = %AnimationPlayer
	player = owner

func on_enter()->void:
	pass

func on_exit()->void:
	pass

func on_update(_delta : float)->void:
	pass

func on_physics_update(_delta : float)->void:
	pass

func is_controllable()-> bool:
	if GameManager.game_state == GameManager.GameState.GAMEPLAY:
		return true
	else:
		return false
