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
var skill_system : SkillSystem
var charging : bool
var charge_timer : float

func _ready():
	super._ready()
	skill_system = player.skill_system
	#animator.animation_finished.connect(on_animation_finish)

func on_enter():
	super.on_enter()
	active_input = true
	charging = true
	charge_timer = 0
	player.velocity = Vector2.ZERO
	animator.play("heal")
	#player.skill_system.skill_sample()

func on_exit():
	super.on_exit()
	active_input = false
	charge_timer = 0
	charging = false

func on_update(_delta : float):	
	if charging and charge_timer < charge_time:
		charge_timer += _delta
	if charging and charge_timer >= charge_time:
		charging = false
		action()

func on_physics_update(_delta : float):
	#player.add_fall_gravity(_delta)
	player.move_and_slide()

func  _unhandled_input(event):
	if not is_controllable(): return
	if not active_input: return
	if event.is_action_released("absorp"):
		action()

func action():
	if charge_timer < charge_time:
		if player.skill_system.is_have_element():
			transition.emit(self,next_normal_sate.name.to_lower())
		else:
			absorp_skill()
	else:
		absorp_skill()

func absorp_skill():
	player.busy_duration = 0.35
	transition.emit(self,next_chrage_sate.name.to_lower())
	player.skill_system.skill_sample()
	animator.play("attack_1")

func on_animation_finish(_animation_name : String):
	if not active_input: return
	if player.is_on_floor():
		transition.emit(self,"idle")
	else:
		transition.emit(self,"fall")
