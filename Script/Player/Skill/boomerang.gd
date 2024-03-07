class_name Boomerang
extends Skill

@onready var ground_collition : CollisionShape2D = $CollisionShape2D
@export var move_time : float

var returning : bool

### ----SUDO----
### move forward attack enemy along the way
### stop and return back to caster after timeout
### cancel if hit ground

func active_skill():
	direction.y = 0
	returning = false
	await get_tree().create_timer(move_time).timeout
	returning = true
	

func _physics_process(delta):
	global_position += direction * (speed * delta)
	if returning:
		direction = (sender.global_position - global_position).normalized()

func on_ground(body: Node2D):
	if returning and body is Player:
		queue_free()
	elif body is TileMap:
		queue_free()
