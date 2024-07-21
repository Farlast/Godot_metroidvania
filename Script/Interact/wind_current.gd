class_name WindCurrent extends Area2D

@export var current_strength : float = 1
@export var wind_direction : Vector2

func _on_body_entered(body:Node2D)->void:
	if not body is Player: return
	body.external_velocity = wind_direction * current_strength

func _on_body_exited(body:Node2D)->void:
	if not body is Player: return
	body.external_velocity = Vector2.ZERO
