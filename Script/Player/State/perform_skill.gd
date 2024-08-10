class_name PerformSkill
extends State

@export var animaion : String = "sample"
@export var cast_time : float = 0.6

var active_input : bool
var input_vector : Vector2

func on_enter()->void:
	super.on_enter()
	active_input = true
	animator.play(animaion)
	player.skill_system.command_familiar()
	player.velocity = Vector2.ZERO

func _unhandled_input(event:InputEvent)->void:
	if not is_controllable(): return
	if not active_input : return
	
	input_vector = input_handle()
	if event.is_action_released("skill"):
		next_state()

func input_handle()->Vector2:
	var h_direction :float = Input.get_axis("move_left", "move_right",)
	var v_direction :float = Input.get_axis("move_up", "move_down")
	if v_direction != 0 and h_direction != 0:
		v_direction = 0
	return Vector2(h_direction,v_direction)

func next_state()->void:
	active_input = false
	player.skill_system.command_familiar()
	if player.is_on_floor() : 
		transition.emit(self,"Idle")
	else :
		transition.emit(self,"fall")
