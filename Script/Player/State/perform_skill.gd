class_name PerformSkill
extends State

@export var animaion : String = "sample"
@export var cast_time : float = 0.6

func on_enter()->void:
	super.on_enter()
	animator.play(animaion)
	player.skill_system.activate_skill()
	player.velocity = Vector2.ZERO
	await get_tree().create_timer(cast_time).timeout
	next_state()
	
func next_state()->void:
	if player.is_on_floor() : 
		transition.emit(self,"Idle")
	else :
		transition.emit(self,"fall")
