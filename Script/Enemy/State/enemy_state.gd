extends Node
class_name EnemyState
signal transition(state : EnemyState , new_state_name : String)

@export var animator : AnimationPlayer
@export var agent : CharacterBody2D

func on_enter():
	#print(name)
	pass

func on_exit():
	pass

func on_update(_delta : float):
	pass

func on_physics_update(_delta : float):
	agent.add_gravity(_delta)
	agent.move_and_slide()
