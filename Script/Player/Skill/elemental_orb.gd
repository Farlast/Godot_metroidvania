class_name ElementalOrb
extends Area2D

### ================
### Orb use for grab object and display current throwable
### 
### ================
signal send_element(element : ElementData, contact_position : Vector2)

### Display
@export var move_speed : float = 6

enum Mode {FOLLOW,HUNT}
var current_mode : Mode
var lerp_target : Node2D
var direction : Vector2
var current_throw_skill : SkillContainer

# Call when find grapable object
func setup(start_position : Vector2, _lerp_target : Node2D,skill_bundle : Grabable):
	current_mode = Mode.FOLLOW
	global_position = start_position
	lerp_target = _lerp_target
	$Sprite2D.texture = skill_bundle.sprite
	current_throw_skill = skill_bundle.throw
	current_throw_skill.request_load_scene()
	show()
	set_process(true)
	set_physics_process(true)

func set_display_off():
	hide()
	set_process(false)
	set_physics_process(false)

func _physics_process(delta):
	lerp_to_player(delta)

func lerp_to_player(delta):
	if is_instance_valid(lerp_target) and current_mode == Mode.FOLLOW:
		global_position = lerp(global_position,lerp_target.global_position, move_speed * delta)
