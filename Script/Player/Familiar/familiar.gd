class_name Familiar extends Area2D

### ================
### follow player by defualt
### place at front of player [skillcharge + projectile]
### have collision can block projectle
### if got attack will change mode between mode1 : mode2
### place at dark alta can purifly area
### summon attack still have 4 no mode effect
### ================
@onready var animaotr : AnimationPlayer = $AnimationPlayer
@onready var direction : Node2D = $Directions
@export var lerp_speed : float = 6

enum MovementMode {FOLLOW,TO_POSITION}
enum Infuse {NORMAL,GHOST_FLAME}
var current_movement_mode : MovementMode
var infuse_status : Infuse
var defualt_target : Node2D
var lerp_target : Node2D
var current_throw_skill : SkillContainer
var object_sprite : Texture2D

func _ready()->void:
	body_entered.connect(on_get_object)
	current_movement_mode = MovementMode.FOLLOW

func _process(delta:float)->void:
	match current_movement_mode:
		MovementMode.FOLLOW:
			lerp_to_position(delta)
			flip_direction()
		MovementMode.TO_POSITION:
			lerp_to_position(delta)

func lerp_to_position(delta:float)->void:
	if is_instance_valid(lerp_target):
		global_position = lerp(global_position,lerp_target.global_position, lerp_speed * delta)

func flip_direction()->void:
	if lerp_target.global_position.x - global_position.x > 0:
		direction.scale.x = abs(direction.scale.x)
	else:
		direction.scale.x = -abs(direction.scale.x) 

func command(node : Node2D)->void:
	match current_movement_mode:
		MovementMode.FOLLOW:
			current_movement_mode = MovementMode.TO_POSITION
			lerp_target = node
		MovementMode.TO_POSITION:
			current_movement_mode = MovementMode.FOLLOW
			lerp_target = defualt_target

### Move to position and grab object
func on_get_object(body : Node2D)->void:
	current_movement_mode = MovementMode.FOLLOW
	infuse_status = Infuse.NORMAL
	current_throw_skill = body.get_object().element_object
	current_throw_skill.request_load_scene()
	animaotr.play("handle")

func throw(system : SkillSystem)->void:
	##Animation move
	current_movement_mode = MovementMode.TO_POSITION
	lerp_target = system.player.front_point
	global_position = system.player.front_point.global_position
	direction.scale.x = system.player.direction_holder.scale.x
	## Active
	current_throw_skill.active_skill(system)
	await system.get_tree().create_timer(0.3).timeout
	current_movement_mode = MovementMode.FOLLOW
	lerp_target = defualt_target
	animaotr.play("idle")
