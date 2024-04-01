extends State
class_name Absorb
####
## get skill when hit skill object
####
var active_input : bool
var skill_system : SkillSystem

func _ready():
	super._ready()
	skill_system = player.skill_system
	animator.animation_finished.connect(on_animation_finish)

func on_enter():
	super.on_enter()
	active_input = true
	player.velocity = Vector2.ZERO
	animator.play("sample")
	
	if player.skill_system.is_have_element():
		player.skill_system.activate_skill()
		player.skill_system.remove_element()
	else:
		player.skill_system.skill_sample()

func on_exit():
	super.on_exit()
	active_input = false

func on_update(_delta : float):
	pass

func on_physics_update(_delta : float):
	player.add_fall_gravity(_delta)
	player.move_and_slide()

func  _unhandled_input(event):
	if not is_controllable(): return
	if not active_input: return
	if event.is_action_released("move_left") || event.is_action_released("move_right"):
		player.velocity = Vector2.ZERO

func on_animation_finish(_animation_name : String):
	if not active_input: return
	if player.is_on_floor():
		transition.emit(self,"idle")
	else:
		transition.emit(self,"fall")
