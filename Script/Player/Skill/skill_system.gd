class_name SkillSystem
extends Node

### ============
### Manage absorb and infuse.
### send absorb command and get object
### press absorb again will throw and lose object
### press infuse will get skill for later use
### ============
signal got_element(element)

@onready var elemental_orb_scene : PackedScene = preload("res://Scenes/Player/elemental_orb.tscn")
@onready var grab_ray : RayCast2D = $"../Directions/Element_ray"

@export var ui_event : CustomEventChannel

enum OrbStatus {InActive,Active}
var orb_status : OrbStatus :
	get:
		return orb_status
	set(value):
		orb_status = value
		player.player_data.orb_status = value
var player : Player
var is_cooldown : bool = false

var elemental_orb:ElementalOrb
var current_skill : SkillContainer

func setup(ref_player : Player):
	player = ref_player
	
func is_orb_active():
	return orb_status == OrbStatus.Active

func inactive_orb():
	orb_status = OrbStatus.InActive
	elemental_orb.set_display_off()

### command orb move forward player
func skill_absorb():
	if grab_ray.is_colliding():
		var coll = grab_ray.get_collider()
		if coll is ElementBox:
			on_got_element(coll,grab_ray.get_collision_point())
		elif coll is SkillMemo:
			swap_skill(coll)

# got an skill from signal/raycast
func on_got_element(_data : ElementBox,_position : Vector2):
	orb_status = OrbStatus.Active
	if is_instance_valid(elemental_orb):
		elemental_orb.global_position = player.front_point.global_position
		elemental_orb.setup(_position,player.orb_anchor,_data.skill_bundle)
	else:
		elemental_orb = elemental_orb_scene.instantiate() as ElementalOrb
		elemental_orb.global_position = player.front_point.global_position
		elemental_orb.setup(_position,player.orb_anchor,_data.skill_bundle)
		player.add_sibling(elemental_orb)

func swap_skill(memo:SkillMemo):
	current_skill = memo.skill
	current_skill.request_load_scene()
	ui_event.texture_event_sended.emit(current_skill.icon)
	memo.pickup()

#region Infuse skill
func is_can_used_skill() -> bool:
	if is_cooldown: return false
	if not is_instance_valid(current_skill) : return false
	return is_have_mana_for_skill(current_skill.cost)

func is_have_mana_for_skill(_cost : float) -> bool:
	return player.player_data.current_mana - _cost >= 0

func activate_skill():
	#if have infuse skill
	if is_instance_valid(current_skill):
		if player.player_data.current_mana - current_skill.cost < 0: return
		player.player_data.current_mana -= current_skill.cost
		player.update_hud_display()
		## change player state and use ability
		current_skill.active_skill(self)
		
		is_cooldown = true
		#player.get_tree().create_timer(skill_cooldown)
		#await player.get_tree().create_timer(skill_cooldown).timeout
		var timer = 0
		while timer < current_skill.cooldown:
			await get_tree().create_timer(0.05).timeout
			timer += 0.05
			ui_event.float_event_sended.emit(timer/current_skill.cooldown)
		is_cooldown = false

func throw_orb():
	if orb_status == OrbStatus.Active:
		## throw orb as prjectile
		elemental_orb.current_throw_skill.active_skill(self)
		inactive_orb()
#endregion
