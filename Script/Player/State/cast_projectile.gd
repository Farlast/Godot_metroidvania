extends State
##-------------------------------##
## stop moving and cast projectile
## can charge for different move set
##-------------------------------##

@export var charge_time : float = 0.25
@export var cooldown: float = 0.3

@export var animation_name : String = "sample"
@export var charge_animation_name : String = "heal"

var active_input : bool
var charge_timer : float

func on_enter()->void:
	animator.animation_finished.connect(on_animation_finish)
	super.on_enter()
	active_input = true
	charge_timer = 0
	player.velocity = Vector2.ZERO
	animator.play(charge_animation_name)
	player.skill_system.command_familiar()
	
func on_exit()->void:
	animator.animation_finished.disconnect(on_animation_finish)
	super.on_exit()
	active_input = false
	charge_timer = 0
	player.skill_system.command_familiar()

func on_update(delta:float)->void:
	charge_timer += delta

func on_animation_finish(_animation_name : String)->void:
	if _animation_name != animation_name : return
	if not active_input: return
	if player.is_on_floor():
		transition.emit(self,"idle")
	else:
		transition.emit(self,"fall")

func _unhandled_input(event:InputEvent)->void:
	if not is_controllable(): return
	if not active_input : return
	if event.is_action_released("action_2"):
		animator.play(animation_name)
		if charge_timer < charge_time:
			var h_direction :float = Input.get_axis("move_left", "move_right",)
			var v_direction :float = Input.get_axis("move_up", "move_down")
			player.skill_system.fire_projectile(Vector2(h_direction,v_direction))
		else:
			player.skill_system.fire_laser()
