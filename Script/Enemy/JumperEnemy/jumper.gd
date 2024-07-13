class_name Jumper extends Enemy

@onready var visions:Area2D = $Visions
var distance : float
var delay : float = 1
var timer : float

func _process(_delta):
	if target:
		distance = abs(target.position.x - position.x)
		if distance > 1000:
			target = null
	

func on_stance_break():
	pass

func on_idle_enter(_state : EnemyState):
	velocity = Vector2.ZERO
	pass

func on_idle_exit(_state : EnemyState):
	pass

func on_idle(_state : EnemyState,_delta : float):
	face_to_target()
	velocity.x = move_toward(velocity.x,0,_delta*10)
	timer += _delta
	if timer < delay: return
	if target != null and is_on_floor():
		timer = 0
		_state.transition.emit(_state,"jump")
	
func on_idle_process(_state : EnemyState,_delta):
	pass

func _on_visions_body_entered(body):
	if body is Player:
		target = body

func face_to_target():
	if target == null: return
	if target.global_position.x < global_position.x:
		direction_holder.scale.x = -abs(direction_holder.scale.x)
	else:
		direction_holder.scale.x = abs(direction_holder.scale.x)
