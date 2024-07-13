class_name Familiar extends Area2D

### ================
### follow player by defualt
### can grab object and display current throwable
### ================
@onready var object_in_hand : Sprite2D = $Directions/ThrowObject
@onready var animaotr : AnimationPlayer = $AnimationPlayer
@onready var direction : Node2D = $Directions
@export var lerp_speed : float = 6

enum Mode {FOLLOW,POSSESSED,TO_POSITION,STAND_BY}
enum Hand {EMPTY,CARRIED}
var current_mode : Mode
var hand_status : Hand
var defualt_target : Node2D
var lerp_target : Node2D
var current_throw_skill : SkillContainer
var object_sprite : Texture2D

func _ready():
	body_entered.connect(on_get_object)
	current_mode = Mode.FOLLOW

func _process(delta):
	match current_mode:
		Mode.FOLLOW:
			lerp_to_position(delta)
			flip_direction()
		Mode.TO_POSITION:
			lerp_to_position(delta)

func lerp_to_position(delta):
	if is_instance_valid(lerp_target):
		global_position = lerp(global_position,lerp_target.global_position, lerp_speed * delta)

func flip_direction():
	if lerp_target.global_position.x - global_position.x > 0:
		direction.scale.x = abs(direction.scale.x)
	else:
		direction.scale.x = -abs(direction.scale.x) 

func command(node : Node2D):
	match current_mode:
		Mode.FOLLOW:
			current_mode = Mode.TO_POSITION
			lerp_target = node
		Mode.TO_POSITION:
			current_mode = Mode.FOLLOW
			lerp_target = defualt_target
		Mode.POSSESSED:
			pass

### Move to position and grab object
func on_get_object(body : GrabbableHost):
	current_mode = Mode.FOLLOW
	hand_status = Hand.CARRIED
	current_throw_skill = body.get_object().element_object
	current_throw_skill.request_load_scene()
	object_in_hand.texture = body.get_object().sprite
	object_in_hand.show()
	animaotr.play("handle")

func throw(system : SkillSystem):
	##Animation move
	current_mode = Mode.TO_POSITION
	lerp_target = system.player.front_point
	global_position = system.player.front_point.global_position
	direction.scale.x = system.player.direction_holder.scale.x
	## Active
	hand_status = Hand.EMPTY
	current_throw_skill.active_skill(system)
	object_in_hand.hide()
	await system.get_tree().create_timer(0.3).timeout
	current_mode = Mode.FOLLOW
	lerp_target = defualt_target
	animaotr.play("idle")
