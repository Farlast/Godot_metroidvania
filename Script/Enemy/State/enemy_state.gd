class_name EnemyState extends Node
signal transition(state : EnemyState , new_state_name : String)

var animator : AnimationPlayer
var agent : Enemy
var state_active :bool

func on_enter():
	state_active = true

func on_exit():
	state_active = false

func on_update(_delta : float):
	pass

func on_physics_update(_delta : float):
	agent.move_and_slide()
