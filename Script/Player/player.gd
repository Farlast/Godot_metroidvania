extends CharacterBody2D
class_name Player

signal attack_success
signal was_dead

@onready var state_machine : StateMachine = $StateMachine
@onready var player_sprite :Sprite2D = $PlayerArt
@onready var pulse_effect : GPUParticles2D = $Directions/Effect/Pulse
@onready var slash_effect : CPUParticles2D = $Directions/Effect/SlashEffect
@onready var direction_holder : Node2D = $Directions
@onready var orb_anchor : Node2D = $Directions/OrbAnchor
@onready var front_point : Node2D = $Directions/FrontPoint
@onready var animation : AnimationPlayer = $AnimationPlayer
@onready var skill_system : SkillSystem = $SkillSystem
@onready var footstep_player : FootstepPlayer = $FootstepPlayer

@export_group("Move")
@export var walk_speed :float = 400.0
@export var knockback_force : float = 500

@export_group("Jump")
@export var jump_velocity :float = -1200.0
@export var gravity_multiply :float = 2.5
@export var coyote_time : float = 0.25
@export var jump_buffer_time : float = 0.2

@export_group("Attack")
@export var attack_system : AttackSystem

@export_group("Health")
@export var hp_event : HealthEvent
@export var mp_event : HealthEvent
@export var player_data : PlayerData
@export var iframe_duration : float = 1.05

@export_group("Dash")
@export var dash_cooldown_time : float = 0.3
var Is_can_dash : bool = true

@export_group("Audio")
@export var hurt_audio : AudioStreamPlayer

var iframe_timer : float
var is_iframe_active : bool

var Is_dead : bool = false
var Is_doublejump_used : bool = true
var Is_can_coyote_time : bool = false
var Is_can_bufferjump : bool = false
var is_can_slide : bool = true
var get_hit_direction : Vector2
var current_element : ElementData
var last_ground_position : Vector2
var temp_damage_data : DamageData
var is_airdash_used : bool = false
var busy_duration: float = 0.5
var animation_iframe : bool
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var globals_sprites_position: Vector2

#region OVERRIDE
func _ready():
	GameManager.game_state_changed.connect(on_game_state_change)
	SceneManager.set_player_position.connect(setup_after_enter_room)
	SceneManager.respawn_at_position.connect(respawn_after_dead)
	attack_system.iframe_start.connect(on_animation_iframe_start)
	attack_system.iframe_end.connect(on_animation_iframe_end)
	
	var shader = player_sprite.material as ShaderMaterial
	shader.set_shader_parameter("active",false)
	globals_sprites_position = player_sprite.global_position
	last_ground_position = global_position
	update_hud_display()
	position_on_start_game()
	
	skill_system.setup(self)

func _process(delta):
	countdown_iframe(delta)
	dash_refill()
	jitter_fix(delta)

func jitter_fix(delta):
	var FPS = Engine.get_frames_per_second()
	var lerp_interval = velocity / FPS
	var lerp_position = global_position + lerp_interval
	globals_sprites_position = globals_sprites_position.lerp(lerp_position, 60 * delta)
	if FPS > 60:
		player_sprite.position = globals_sprites_position - global_position
		player_sprite.position.y += -88
	else:
		player_sprite.position = Vector2(0, -88)
#endregion
#region Set Position and Status
###############
## CUSTOM
###############
func on_game_state_change(game_state : GameManager.GameState):
	if game_state == GameManager.GameState.GAMEPLAY:
		set_process(true)
		set_physics_process(true)
	elif game_state == GameManager.GameState.FREEZE:
		set_process(false)
		set_physics_process(false)
	elif game_state == GameManager.GameState.LOCK_CONTROLL:
		set_process(true)
		set_physics_process(true)

func position_on_start_game():
	if SceneManager.need_respawn:
		global_position = player_data.position
		SceneManager.need_respawn = false

func setup_after_enter_room(exit_position):
	global_position = exit_position
	state_machine.current_state.transition.emit(state_machine.current_state,"fall")

func set_last_ground_position():
	last_ground_position = global_position

func reset_position():
	global_position = last_ground_position

func refill_health():
	player_data.current_health = player_data.max_health
	player_data.current_mana = player_data.max_mana
	update_hud_display()

func respawn_after_dead(new_position : Vector2):
	global_position = new_position
	player_data.current_health = player_data.max_health
	update_hud_display()
	state_machine.current_state.transition.emit(state_machine.current_state,"idle")

func update_hud_display():
	hp_event.change.emit(player_data.current_health,player_data.max_health)
	mp_event.change.emit(player_data.current_mana,player_data.max_mana)
#endregion
#region Statemacthaine
func add_fall_gravity(delta):
	if not is_on_floor() :
		velocity.y += gravity * gravity_multiply * delta
	else:
		Is_doublejump_used = false
	if velocity.y > 1500:
		velocity.y = 1500

func add_drag(delta : float, check_on_floor : bool = true, drag : float = 5):
	if check_on_floor:
		if not is_on_floor(): return
	
	if velocity.x > 0:
		velocity.x -= abs(velocity.x * (delta * drag))
	else:
		velocity.x += abs(velocity.x * (delta * drag))

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
	update_area()

func update_area():
	if not direction_holder: return
	if player_sprite.flip_h:
		direction_holder.scale.x = -abs(direction_holder.scale.x)
	else:
		direction_holder.scale.x = abs(direction_holder.scale.x)

func check_coyote_time():
	Is_can_coyote_time = true
	await get_tree().create_timer(coyote_time).timeout
	Is_can_coyote_time = false

func check_double_jump() -> bool:
	return not Is_doublejump_used && not is_on_floor() and player_data.is_doublejump_unlock

func check_jumpbuffer_time():
	Is_can_bufferjump = true
	await get_tree().create_timer(jump_buffer_time).timeout
	Is_can_bufferjump = false

func dash_refill():
	if is_on_floor():
		is_airdash_used = false

func dash_cooldown():
	Is_can_dash = false
	await get_tree().create_timer(dash_cooldown_time).timeout
	Is_can_dash = true

func is_can_dash():
	if not player_data.is_dash_unlock and not is_on_floor():
		return false
	else:
		return Is_can_dash && not is_airdash_used

func slide_cooldown(slide_cooldown_time : float):
	is_can_slide = false
	await get_tree().create_timer(slide_cooldown_time).timeout
	is_can_slide = true

### Ghost call
func  is_can_use_skill(event : InputEvent) -> bool:
	if not event.is_action_pressed("absorp"): return false
	if not player_data.is_skill_unlock: return false
	return true

### Skill
func is_can_cast_skill(event : InputEvent):
	if not event.is_action_pressed("skill"): return false
	if not player_data.is_skill_unlock: return false
	return skill_system.is_can_used_skill()

#region heal
func is_can_heal(event : InputEvent)-> bool:
	if not event.is_action_pressed("heal"): return false
	if not skill_system.is_have_mana_for_skill(2): return false
	return true

func start_heal():
	$AnimationPlayer.play("heal")
	busy_duration = 1.0
	state_machine.current_state.transition.emit(state_machine.current_state,"busy")

func heal():
	if player_data.current_health < player_data.max_health:
		player_data.current_mana -= 2
		player_data.current_health += 1
	update_hud_display()
#endregion
#endregion
#region Attack and damage
func take_damage(damage_data : DamageData)->bool:
	if damage_data.take_damage_rule != DamageData.TakeDamageRule.RESET:
		if is_iframe_active:
			return false
		if animation_iframe :
			return false
	
	is_iframe_active = true
	iframe_timer = 0
	player_data.current_health -= damage_data.damage
	
	slash_effect.restart()
	pulse_effect.restart()
	hurt_audio.play()
	
	if player_data.current_health <= 0:
		hp_event.change.emit(player_data.current_health,player_data.max_health)
		on_dead()
	else:
		temp_damage_data = damage_data
		hp_event.change.emit(player_data.current_health,player_data.max_health)
		state_machine.current_state.transition.emit(state_machine.current_state,"knockback")
	return true

func on_dead():
	was_dead.emit()
	state_machine.current_state.transition.emit(state_machine.current_state,"empty")
	$AnimationPlayer.play("hit")
	GameManager.time_manager.freeze_time_duration()
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

func on_animation_iframe_start():
	animation_iframe = true
func on_animation_iframe_end():
	animation_iframe = false

func attack_feedback(report:AttackReport):
	if report.success:
		## for knockback from attack
		get_hit_direction = (report.receiver_position - global_position).normalized()
		attack_success.emit()
	if report.object_tag == AttackReport.ObjectTag.ENEMY:
		## Get mana from attack enemy
		player_data.current_mana += 0.5
		mp_event.change.emit(player_data.current_mana,player_data.max_mana)

#endregion
#region Unlockable
func pick_up_upgrade(unlock : Unlockable):
	match unlock.unlock_type:
		Unlockable.UnlockType.DASH:
			player_data.is_dash_unlock = true
		Unlockable.UnlockType.DOUBLE_JUMP:
			player_data.is_doublejump_unlock = true
		Unlockable.UnlockType.SPIRIT_CALL:
			player_data.is_skill_unlock = true
#endregion
