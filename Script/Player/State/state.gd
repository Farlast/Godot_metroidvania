extends Node
class_name State

signal transition(state : State , new_state_name : String)

@export var animator : AnimationPlayer
@export var player : Player

func _ready():
	animator = %AnimationPlayer
	player = owner

func on_enter():
	#print(name)
	pass

func on_exit():
	pass

func on_update(_delta : float):
	pass

func on_physics_update(_delta : float):
	pass
