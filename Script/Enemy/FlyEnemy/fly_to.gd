class_name FlyTo extends EnemyState

@export var check_area : Area2D
@export var move_speed : float = 200
@export var offset : float = 64

var target_direction : Vector2
var target_position : Vector2

func on_enter()->void:
	super.on_enter()
	check_area.body_entered.connect(set_target)

func on_exit()->void:
	super.on_exit()
	check_area.body_entered.disconnect(set_target)

func set_target(body:Node2D)->void:
	agent.target = body

func on_update(delta:float)->void:
	super.on_update(delta)

func on_physics_update(_delta : float)->void:
	if agent.target:
		target_position = Vector2(agent.target.position.x,agent.target.position.y - offset)
		target_direction = Vector2(target_position - agent.position).normalized()
		agent.velocity = target_direction * move_speed
	agent.move_and_slide()
