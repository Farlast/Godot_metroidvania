extends Enemy
class_name ChaseEnemy

@onready var front_ray : RayCast2D = $Direction/FrontRay
@onready var down_ray : RayCast2D = $Direction/DownRay
@onready var soul := preload("res://Scenes/Interactable/skill_memo.tscn")

@export_category("Movement")
@export var move_speed : float = 200
@export var turn_left : bool = true
@export var turning : bool

@export var stunt_time : float
@export var onscreen_noti : VisibleOnScreenNotifier2D

var is_on_screen : bool

func _ready():
	super._ready()
	
	if direction_holder.scale.x > 0:
		turn_left = true
	else:
		turn_left = false

func take_damage(damage_data : DamageData)->bool:
	super.take_damage(damage_data)
	if not super_armor and health_system.stance.current_value > 0:
		if health_system.health.current_value > 0:
			state_machine.current_state.transition.emit(state_machine.current_state,"stagger")
	if target == null:
		if turn_left:
			turn_left = false
			direction_holder.scale.x = -abs(direction_holder.scale.x)
		else:
			turn_left = true
			direction_holder.scale.x = abs(direction_holder.scale.x)
	return true

func on_idle(state : EnemyState):
	if not is_on_floor():return
	if front_ray.is_colliding():
		target = front_ray.get_collider() as Node2D
		state.transition.emit(state,"chase")
	elif target != null:
		state.transition.emit(state,"chase")
		face_to_target(false)

func face_to_target(delay :bool = true):
	if target == null: return
	if turning : return
	turning = true
	if target.global_position.x > global_position.x:
		if delay: await get_tree().create_timer(0.3).timeout
		turn_left = false
		turning = false
		direction_holder.scale.x = -abs(direction_holder.scale.x)
	else:
		if delay: await get_tree().create_timer(0.3).timeout
		turning = false
		turn_left = true
		direction_holder.scale.x = abs(direction_holder.scale.x)

func on_stance_break():
	if not health_system.is_dead():
		state_machine.current_state.transition.emit(state_machine.current_state,"stancebreak")

func dead():
	state_machine.current_state.transition.emit(state_machine.current_state,"empty")
	var scene :SkillMemo= soul.instantiate()
	scene.position = front_ray.global_position
	add_sibling.call_deferred(scene)
	if is_on_screen:
		var camera = GameManager.main_camera
		camera.add_trauma(0.5)
	super.dead()

func on_screen_enter():
	is_on_screen = true

func on_screen_exit():
	is_on_screen = false
