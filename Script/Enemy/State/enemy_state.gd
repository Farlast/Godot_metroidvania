class_name EnemyState extends Node
signal transition(state : EnemyState , new_state_name : String)

var animator : AnimationPlayer
var agent : Enemy

func on_enter():
	pass

func on_exit():
	pass

func on_update(_delta : float):
	pass

func on_physics_update(_delta : float):
	agent.add_gravity(_delta)
	agent.move_and_slide()
