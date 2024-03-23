extends Enemy
class_name ChaseEnemy

@onready var front_ray : RayCast2D = $Direction/FrontRay

@export_category("Movement")
@export var move_speed : float = 200
@export var turn_left : bool = true

@export var hp_bar : StatusBar
@export var stagger_bar : StatusBar

@export var stunt_time : float
@export var onscreen_noti : VisibleOnScreenNotifier2D

var target : Node2D

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
	hp_bar.update_hp(health_system.health.current_value,health_system.health.max_value)
	stagger_bar.update_hp(health_system.stance.current_value,health_system.stance.max_value)
	return true

func on_idle(state : EnemyState):
	if not is_on_floor():return
	
	if front_ray.is_colliding():
		target = front_ray.get_collider() as Node2D
		state.transition.emit(state,"chase")
	elif target != null:
		face_to_target(false)
		state.transition.emit(state,"chase")

func on_in_attack_range(state : EnemyState,_delta : float):
	state.transition.emit(state,"rampattack")
	
func face_to_target(delay :bool = true):
	if target == null: return
	if target.global_position.x > global_position.x:
		if delay: await get_tree().create_timer(0.3).timeout
		turn_left = false
		direction_holder.scale.x = -abs(direction_holder.scale.x)
	else:
		if delay: await get_tree().create_timer(0.3).timeout
		turn_left = true
		direction_holder.scale.x = abs(direction_holder.scale.x)

func on_stance_break():
	velocity = Vector2.ZERO
	animator.play("stagger")
	state_machine.current_state.transition.emit(state_machine.current_state,"empty")
	await get_tree().create_timer(stunt_time).timeout
	state_machine.current_state.transition.emit(state_machine.current_state,"idle")
	health_system.stance.add(health_system.stance.max_value)
	stagger_bar.update_hp(health_system.stance.current_value,health_system.stance.max_value)

var is_on_screen : bool

func dead():
	if is_on_screen:
		var camera = GameManager.main_camera
		camera.add_trauma(0.5)
	super.dead()

func on_screen_enter():
	is_on_screen = true

func on_screen_exit():
	is_on_screen = false
