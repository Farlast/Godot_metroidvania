class_name AttackCombo
extends State

@export_group("State transition")
@export var animation_name : String = "attack"
@export var next_attack_sate : State
@export var input_active : String = "attack"
@export_group("Damage")
@export var attack_box : AttackBox
@export var damage_data : DamageData
@export_group("Audio")
@export var attack_audio : AudioStreamPlayer2D
@export_group("Move distance")
@export var velocity_move : Vector2 = Vector2(200,0)
@export var air_fix_movement : bool
@export var fall_gravity : bool = true
@export var knockback_from_attack : bool = true

var attack_box_col : CollisionShape2D
var active_input : bool
var attack_buffer : bool  = false
var listen_input_window : bool
var direction : float
var attack_system : AttackSystem

func _ready()->void:
	super._ready()
	animator.animation_finished.connect(on_animation_finish)
	player.attack_success.connect(on_attack_success)
	attack_box_col = attack_box.get_child(0)
	attack_system = player.attack_system

############
## Custom
############
func on_enter()->void:
	attack_box.get_damage_data().add(damage_data)
	super.on_enter()
	if air_fix_movement:
		player.velocity = Vector2(player.direction_holder.scale.x * velocity_move.x,velocity_move.y)
	else:
		player.velocity = Vector2(player.velocity.x,player.velocity.y/2)
	active_input = true
	listen_input_window = false
	play_animation()
	attack_audio.play()
	attack_system.enable_hitbox.connect(enable_hitbox)
	attack_system.disable_hitbox.connect(disable_hitbox)
	attack_system.allow_skip_animation.connect(allow_next_animation)

func on_attack_success()->void:
	if not active_input: return
	if not knockback_from_attack: return
	if player.get_hit_direction != Vector2.ZERO:
		player.velocity.x += (-player.get_hit_direction.x * velocity_move.x)

func on_animation_finish(_animation_name : String)->void:
	disable_hitbox()
	if not active_input: return
	end_state()

func end_state()->void:
	if player.is_on_floor() : 
		transition.emit(self,"Idle")
	else :
		transition.emit(self,"fall")

func on_exit()->void:
	super.on_exit()
	disable_hitbox()
	active_input = false
	attack_buffer = false
	player.get_hit_direction = Vector2.ZERO
	attack_system.enable_hitbox.disconnect(enable_hitbox)
	attack_system.disable_hitbox.disconnect(disable_hitbox)
	attack_system.allow_skip_animation.disconnect(allow_next_animation)

func on_physics_update(_delta : float)->void:
	super.on_physics_update(_delta)
	if air_fix_movement:
		player.velocity.y = 0
	if fall_gravity:
		player.add_fall_gravity(_delta)
	player.add_drag(_delta)
	player.move_and_slide()

func  _unhandled_input(event:InputEvent)->void:
	if not is_controllable(): return
	if not active_input: return
	if air_fix_movement and event.is_action_released("move_left") || event.is_action_released("move_right"):
		player.velocity.x = 0
	if event.is_action_pressed("dash") && player.is_can_dash():
		transition.emit(self,"dash")
	elif event.is_action_pressed("jump") && player.is_on_floor():
		transition.emit(self,"Jump")
	elif event.is_action_pressed(input_active):
		attack_buffer = true
		if listen_input_window:
			allow_next_animation()

func play_animation()->void:
	animator.play(animation_name)

### call by animation
func enable_hitbox()->void:
	attack_box_col.set_deferred("disabled",false)

func disable_hitbox()->void:
	attack_box_col.set_deferred("disabled",true)

func allow_next_animation()->void:
	### allow exit state before animation finish
	listen_input_window = true
	if not active_input: return
	if attack_buffer:
		listen_input_window = false
		next_combo_state()

func next_combo_state()->void:
	if next_attack_sate:
		transition.emit(self,next_attack_sate.name.to_lower())
