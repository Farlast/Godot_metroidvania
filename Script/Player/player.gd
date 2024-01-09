extends CharacterBody2D
class_name Player

@export_group("component")
@export var state_machine : StateMachine
@onready var player_sprite :Sprite2D = $PlayerArt
@onready var pulse_effect : GPUParticles2D = $Effect/Pulse
@onready var slash_effect : CPUParticles2D = $Effect/SlashEffect

@export_group("Move")
@export var walk_speed :float = 400.0
@export var knockback_force : float = 500

@export_group("Jump")
@export var jump_velocity :float = -1200.0
@export var gravity_multiply :float = 2.5
@export var coyote_time : float = 0.25
@export var jump_buffer_time : float = 0.2

@export_group("Attack")
@export var attack_speed : float = 0.15
@onready var attackBox : Area2D = $AttackBox

@export_group("Health")
@export var hp_event : HealthEvent
@export var player_data : PlayerData
@export var iframe_duration : float = 1.05

@export_group("Dash")
@export var dash_cooldown_time : float = 0.3
var Is_can_dash : bool

@export_group("Audio")
@export var hurt_audio : AudioStreamPlayer

var iframe_timer : float
var is_iframe_active : bool

@onready var attack_area : CollisionShape2D = $AttackBox/AttackArea
@onready var absorb_area : CollisionShape2D = $"GetElementBox/Absorb Area"

var Is_dead : bool
var Is_doublejump_used : bool
var Is_can_coyote_time : bool
var Is_can_bufferjump : bool
var Is_can_attack : bool
var get_hit_direction : Vector2
var current_element : ElementData
var last_ground_position : Vector2
var temp_damage_data : DamageData
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#region OVERRIDE
###############
## OVERRIDE
###############
func _ready():
	Is_can_attack = true
	Is_can_dash = true
	Is_doublejump_used = false
	Is_can_bufferjump = false
	Is_can_coyote_time = false
	is_iframe_active = false
	last_ground_position = global_position
	var shader = player_sprite.material as ShaderMaterial
	shader.set_shader_parameter("active",false)
	
	hp_event.change_HP.emit(player_data.current_health,player_data.max_health)
	SceneManager.set_player_position.connect(setup_after_enter_room)
	SceneManager.respawn_at_position.connect(respawn_after_dead)
	
func _process(delta):
	countdown_iframe(delta)
#endregion
#region Set Position and Status
###############
## CUSTOM
###############
func setup_after_enter_room(exit_position):
	global_position = exit_position
	state_machine.current_state.transition.emit(state_machine.current_state,"fall")

func set_last_ground_position():
	last_ground_position = global_position

func reset_position():
	global_position = last_ground_position

func refill_health():
	player_data.current_health = player_data.max_health
	hp_event.change_HP.emit(player_data.current_health,player_data.max_health)

func respawn_after_dead(new_position : Vector2):
	global_position = new_position
	player_data.current_health = player_data.max_health
	hp_event.change_HP.emit(player_data.current_health,player_data.max_health)
	state_machine.current_state.transition.emit(state_machine.current_state,"idle")
	
func pick_up_upgrade():
	pass

func pick_up_doublejump_unlock():
	player_data.is_doublejump_unlock = true

func pick_up_dash_unlock():
	player_data.is_dash_unlock = true
#endregion
#region Statemacthaine
func add_fall_gravity(delta):
	if not is_on_floor() :
		velocity.y += gravity * gravity_multiply * delta
	else:
		Is_doublejump_used = false

func move_horizontal(flip : bool = true):
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * walk_speed
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)
	
	if flip:
		flip_sprite(direction)

func flip_sprite(direction : float):
	if direction > 0:
		player_sprite.flip_h = false
	elif direction < 0:
		player_sprite.flip_h = true
		
func update_area():
	if attack_area == null: return
	if absorb_area == null: return
	if player_sprite.flip_h:
		attack_area.position.x = -abs(attack_area.position.x)
		absorb_area.position.x = -abs(attack_area.position.x)
	else:
		attack_area.position.x = abs(attack_area.position.x)
		absorb_area.position.x = abs(absorb_area.position.x)

func check_coyote_time():
	Is_can_coyote_time = true
	await get_tree().create_timer(coyote_time).timeout
	Is_can_coyote_time = false
	
func check_jumpbuffer_time():
	Is_can_bufferjump = true
	await get_tree().create_timer(jump_buffer_time).timeout
	Is_can_bufferjump = false

#endregion
#region Attack and damage
func take_damage(damage_data : DamageData):
	if is_iframe_active: return
	is_iframe_active = true
	iframe_timer = 0
	player_data.current_health -= damage_data.damage
	slash_effect.restart()
	pulse_effect.restart()
	hurt_audio.play()
	if player_data.current_health <= 0:
		player_data.current_health = 0
		hp_event.change_HP.emit(player_data.current_health,player_data.max_health)
		on_dead()
	else:
		temp_damage_data = damage_data
		hp_event.change_HP.emit(player_data.current_health,player_data.max_health)
		state_machine.current_state.transition.emit(state_machine.current_state,"knockback")

func on_dead():
	state_machine.current_state.transition.emit(state_machine.current_state,"empty")
	$AnimationPlayer.play("hit")
	TimeManager.freeze_time_duration()
	await get_tree().create_timer(0.5).timeout
	SceneManager.respawn_last_savepoint()

func countdown_iframe(delta : float):
	if not is_iframe_active: return
	iframe_timer += delta
	var shader = player_sprite.material as ShaderMaterial
	
	if iframe_timer >= iframe_duration:
		is_iframe_active = false
		iframe_timer = 0
		shader.set_shader_parameter("active",false)
	else :
		var value = sin(iframe_timer * 20) * 10
		if value > 9:
			shader.set_shader_parameter("active",true)
		else: 
			shader.set_shader_parameter("active",false)
func attack_feedback(hurtbox:HurtBox):
	if hurtbox == null : return 
	get_hit_direction = (hurtbox.global_position - global_position).normalized()
	if get_hit_direction != Vector2.ZERO:
		velocity.x = knockback_force/2 * -get_hit_direction.x

func attack_cooldown():
	Is_can_attack = false
	await get_tree().create_timer(attack_speed).timeout
	Is_can_attack = true

func dash_cooldown():
	Is_can_dash = false
	await get_tree().create_timer(dash_cooldown_time).timeout
	Is_can_dash = true
#endregion
