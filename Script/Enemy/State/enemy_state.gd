class_name EnemyState extends Node
signal transition(state : EnemyState , new_state_name : String)

var animator : AnimationPlayer
var agent : Enemy
var state_active :bool

func on_enter()->void:
	state_active = true

func on_exit()->void:
	state_active = false

func on_update(_delta : float)->void:
	pass

func on_physics_update(_delta : float)->void:
	agent.move_and_slide()
