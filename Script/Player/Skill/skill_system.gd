class_name SkillSystem
extends Node2D

@onready var elemental_orb_scene : PackedScene = preload("res://Scenes/Player/elemental_orb.tscn")
@onready var elemental_display_scene : PackedScene = preload("res://Scenes/Player/Elemental_Display.tscn")
@onready var water_jet_scene : PackedScene = preload("res://Scenes/Player/water_splash.tscn")
#@onready var water_jet_scene : PackedScene = preload("res://Scenes/Player/skill_boomerang.tscn")
@onready var plant_bullet_scene : PackedScene = preload("res://Scenes/Player/rock_bullet.tscn")
@onready var fire_bullet_scene : PackedScene = preload("res://Scenes/Player/fireball.tscn")

enum OrbStatus {InActive,Active}
var orb_status : OrbStatus :
	get:
		return orb_status
	set(value):
		orb_status = value
		player.player_data.orb_status = value		
var current_orb_element : ElementData.ElementType:
	get:
		return current_orb_element
	set(value):
		current_orb_element = value
		player.player_data.current_orb_element = value
var current_used_element : ElementData.ElementType:
	get:
		return current_used_element
	set(value):
		current_used_element = value
		player.player_data.current_used_element = value

var player : Player
var follow_orb : ElementalDisplay
var cost : float = 2
var heal_cost : float = 2
var skill_cooldown : float = 0.3
var is_cooldown : bool = false

func setup_after_reload():
	current_orb_element = player.player_data.current_orb_element
	current_used_element = player.player_data.current_used_element
	if player.player_data.orb_status == OrbStatus.Active:
		follow_orb = elemental_display_scene.instantiate() as ElementalDisplay
		follow_orb.setup(player.orb_anchor.position,player.orb_anchor,current_orb_element)
		player.owner.add_child.call_deferred(follow_orb)
		orb_status = player.player_data.orb_status

func setup(ref_player : Player):
	player = ref_player

func is_can_used_skill() -> bool:
	return player.player_data.current_mana - cost >= 0

func is_have_mana_for_skill(_cost : float) -> bool:
	return player.player_data.current_mana - _cost >= 0

func skill_sample():
	var h_direction = Input.get_axis("move_left", "move_right")
	var v_direction = Input.get_axis("move_up", "move_down")
	if h_direction == 0 and v_direction == 0:
		h_direction = player.direction_holder.scale.x
	# instance bullet if bulet hit it will send signal back
	var elemental_orb := elemental_orb_scene.instantiate() as ElementalOrb
	elemental_orb.global_position = player.front_point.global_position
	elemental_orb.direction = Vector2(h_direction,v_direction)
	elemental_orb.send_element.connect(got_element)
	player.get_parent().add_child(elemental_orb)

# got an element from signal
func got_element(element_data : ElementData,_position : Vector2):
	orb_status = OrbStatus.Active
	current_orb_element = element_data.element
	if follow_orb: # if old one still exist
		follow_orb.set_display_off()
		follow_orb.setup(_position,player.orb_anchor,current_orb_element)
	else:
		follow_orb = elemental_display_scene.instantiate() as ElementalDisplay
		follow_orb.setup(_position,player.orb_anchor,current_orb_element)
		player.get_parent().add_child(follow_orb)

func activate_skill():
	if orb_status == OrbStatus.Active:
		if player.player_data.current_mana - cost < 0: return
		player.player_data.current_mana -= cost
		player.update_hud_display()
		
		var skill_scene : PackedScene
		
		match current_orb_element:
			ElementData.ElementType.WATER:
				skill_scene = water_jet_scene
			ElementData.ElementType.FIRE:
				skill_scene = fire_bullet_scene
			ElementData.ElementType.POISON:
				skill_scene = plant_bullet_scene
			_:
				return
		
		## fire prjectile skill
		var skill_ins := skill_scene.instantiate() as Skill
		skill_ins.constructor(player.front_point,player.front_point.global_position,player.direction_holder.scale)
		player.add_sibling(skill_ins)
		skill_ins.active_skill()
		
		is_cooldown = true
		await player.get_tree().create_timer(skill_cooldown).timeout
		is_cooldown = false
