class_name SkillSystem
extends Node2D

signal got_element(element)

@onready var elemental_orb_scene : PackedScene = preload("res://Scenes/Player/elemental_orb.tscn")
@onready var elemental_display_scene : PackedScene = preload("res://Scenes/Player/Elemental_Display.tscn")
@onready var skill_boomerang_scene : PackedScene = preload("res://Scenes/Player/skill_boomerang.tscn")

@export var fire_skill_container : SkillContainer
@export var water_skill_container : SkillContainer
@export var grass_skill_container : SkillContainer
var current_skill_container : SkillContainer

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

var heal_cost : float = 2
var skill_cooldown : float = 0.3
var is_cooldown : bool = false

func setup_after_reload():
	current_orb_element = player.player_data.current_orb_element
	current_used_element = player.player_data.current_used_element
	fire_skill_container.load_scene()
	water_skill_container.load_scene()
	grass_skill_container.load_scene()
	current_skill_container = fire_skill_container
	if player.player_data.orb_status == OrbStatus.Active:
		follow_orb = elemental_display_scene.instantiate() as ElementalDisplay
		follow_orb.setup(player.orb_anchor.position,player.orb_anchor,current_orb_element)
		player.owner.add_child.call_deferred(follow_orb)
		orb_status = player.player_data.orb_status

func setup(ref_player : Player):
	player = ref_player

func is_can_used_skill() -> bool:
	return player.player_data.current_mana - current_skill_container.cost >= 0

func is_have_mana_for_skill(_cost : float) -> bool:
	return player.player_data.current_mana - _cost >= 0

func is_have_element():
	return orb_status == OrbStatus.Active

func remove_element():
	orb_status = OrbStatus.InActive
	follow_orb.queue_free()

func skill_sample():
	if orb_status == OrbStatus.Active:
		activate_skill()
		return
	# instance bullet if bulet hit it will send signal back
	var h_direction = player.direction_holder.scale.x
	var elemental_orb := elemental_orb_scene.instantiate() as ElementalOrb
	elemental_orb.global_position = player.front_point.global_position
	elemental_orb.direction = Vector2(h_direction,0)
	elemental_orb.send_element.connect(on_got_element)
	player.get_parent().add_child(elemental_orb)

# got an element from signal
func on_got_element(element_data : ElementData,_position : Vector2):
	orb_status = OrbStatus.Active
	current_orb_element = element_data.element
	if is_instance_valid(follow_orb): # if old one still exist
		follow_orb.set_display_off()
		follow_orb.setup(_position,player.orb_anchor,current_orb_element)
	else:
		follow_orb = elemental_display_scene.instantiate() as ElementalDisplay
		follow_orb.setup(_position,player.orb_anchor,current_orb_element)
		player.get_parent().add_child(follow_orb)
	match current_orb_element:
		ElementData.ElementType.WATER:
			current_skill_container = water_skill_container
		ElementData.ElementType.FIRE:
			current_skill_container = fire_skill_container
		ElementData.ElementType.POISON:
			current_skill_container = grass_skill_container
		_:
			return

func activate_skill():
	if orb_status == OrbStatus.Active:
		if player.player_data.current_mana - current_skill_container.cost < 0: return
		player.player_data.current_mana -= current_skill_container.cost
		player.update_hud_display()
		## fire prjectile skill
		var skill_ins :SkillEmiter = current_skill_container.get_scene().instantiate() as SkillEmiter
		skill_ins.constructor(player.front_point,
		player.front_point.global_position,
		player.direction_holder.scale)
		player.add_sibling(skill_ins)
		skill_ins.active_skill()
		
		is_cooldown = true
		await player.get_tree().create_timer(skill_cooldown).timeout
		is_cooldown = false

func chrage_skill_active():
	var skill_ins := skill_boomerang_scene.instantiate() as SkillEmiter
	skill_ins.constructor(player.front_point,
	player.front_point.global_position,
	player.direction_holder.scale)
	player.add_sibling(skill_ins)
	skill_ins.active_skill()
