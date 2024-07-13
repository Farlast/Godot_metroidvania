extends State
class_name Absorb
####
## get skill when hit skill object
## press to absorb
####

@export var charge_time : float = 0.25
@export var cooldown: float = 0.3

@export var next_normal_sate : State 
@export var next_chrage_sate : State 

var active_input : bool
var charging : bool
var charge_timer : float

func on_enter():
	animator.animation_finished.connect(on_animation_finish)
	super.on_enter()
	active_input = true
	charging = true
	charge_timer = 0
	player.velocity = Vector2.ZERO
	animator.play("sample")
	player.skill_system.command_familiar()
	
	#if player.skill_system.is_orb_active():
		#animator.play("sample")
		#player.skill_system.throw_orb()
	#else:
		#animator.play("sample")
		#player.skill_system.skill_absorb()

func on_exit():
	animator.animation_finished.disconnect(on_animation_finish)
	super.on_exit()
	active_input = false
	charge_timer = 0
	charging = false

func on_physics_update(_delta : float):
	#player.add_fall_gravity(_delta)
	player.move_and_slide()

func on_animation_finish(_animation_name : String):
	if not active_input: return
	if player.is_on_floor():
		transition.emit(self,"idle")
	else:
		transition.emit(self,"fall")
