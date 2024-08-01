class_name SkillSystem
extends Node

### ============
### Lantern and skill manager
### ============

@onready var familiar_scene : PackedScene = preload("res://Scenes/Player/familiar.tscn")

@export_group("Projectile position")
@export var front_point : Node2D
@export var crouch_point : Node2D
@export var up_point : Node2D

@export_group("Projectile skill")
@export var ui_event : CustomEventChannel
@export var feather : SingleBullet
#@export var ghostflamefeather : SingleBullet
@onready var laser_scene : PackedScene = preload("res://Scenes/Effect/laser.tscn")
@export var laser_audio : AudioStream


@export_group("Lantern skill")
@export var current_skill : SkillContainer
#@export var basic_skill : SkillContainer # burn corruption out of object/enemy
#@export var upward_skill : SkillContainer # anti air skill
#@export var crouch_skill : SkillContainer # summon flower tree platform
#@export var airstomp_skill : SkillContainer # breakground
#---------------------------
# skill main element is dark / ghostflame
# dark : dark flower, reaper of the deep
# ghostflame : death bird
var player : Player
var familiar : Familiar
var is_cooldown : bool = false

func setup(ref_player : Player)->void:
	player = ref_player
	familiar = familiar_scene.instantiate() as Familiar
	familiar.defualt_target = player.orb_anchor
	familiar.lerp_target = player.orb_anchor
	player.add_sibling.call_deferred(familiar)

#region Familiar skill
func is_familiar_ready(event:InputEvent)->bool:
	if not event.is_action_pressed("skill"): return false
	return true

func command_familiar()->void:
	familiar.command(front_point)
	pass

#endregion
#region skill
func is_projectile_ready(event : InputEvent) -> bool:
	if not event.is_action_pressed("action_2"): return false
	#if not player.player_data.is_abilitie_unlock("projectile_skill"): return false
	if not is_instance_valid(feather) : return false
	if feather.is_cooldown: return false
	#is have mana for skill
	return player.player_data.current_mana - feather.cost>= 0

func fire_projectile(direction : Vector2)->void:
	player.player_data.current_mana -= current_skill.cost
	player.update_hud_display()
	if direction.x != 0 and direction.y != 0:
		direction.y = 0
	if direction.y > 0:
		direction.y = 0
	if direction == Vector2.ZERO:
		direction.x = player.direction_holder.scale.x
	if direction == Vector2.UP:
		feather.fire_bullet(up_point,direction,player)
	else:
		feather.fire_bullet(front_point,direction,player)
	feather.set_cooldown(player)

func crouch_fire_projectile()->void:
	player.player_data.current_mana -= current_skill.cost
	player.update_hud_display()
	var direction : Vector2 = Vector2(player.direction_holder.scale.x,0)
	feather.fire_bullet(crouch_point,direction,player)
	feather.set_cooldown(player)

func midair_fire_projectile(direction : Vector2)->void:
	player.player_data.current_mana -= current_skill.cost
	player.update_hud_display()
	if direction.x != 0 and direction.y != 0:
		direction.x = 0
	if direction == Vector2.ZERO:
		direction.x = player.direction_holder.scale.x
	if direction == Vector2.UP:
		feather.fire_bullet(up_point,direction,player)
	elif direction == Vector2.DOWN:
		feather.fire_bullet(player,direction,player)
	else:
		feather.fire_bullet(front_point,direction,player)
	feather.set_cooldown(player)

func fire_laser()->void:
	var au_player :AudioPlayer = GameManager.audio_player
	au_player.play(laser_audio,player.position)
	var laser :Laser = laser_scene.instantiate() as Laser
	laser.global_position = front_point.global_position
	laser.scale = player.direction_holder.scale
	add_child(laser)
	laser.is_casting = true
	await get_tree().create_timer(0.3).timeout
	laser.is_casting = false
	await get_tree().create_timer(0.3).timeout
	laser.queue_free()
#endregion
