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

enum OrbStatus {InActive,Active}
var orb_status : OrbStatus :
	get:
		return orb_status
	set(value):
		orb_status = value
		player.player_data.orb_status = value
var player : Player
var skill_cooldown : float = 0.3
var is_cooldown : bool = false

var elemental_orb:ElementalOrb
var current_infuse_skill : SkillContainer

func setup(ref_player : Player):
	player = ref_player
	
func is_orb_active():
	return orb_status == OrbStatus.Active

func inactive_orb():
	orb_status = OrbStatus.InActive
	elemental_orb.set_display_off()

### command orb move forward player
func skill_absorb():
	# instance bullet if bulet hit it will send signal back
	
	if grab_ray.is_colliding():
		var coll : ElementBox = grab_ray.get_collider()
		on_got_element(coll,grab_ray.get_collision_point())

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

#region Infuse skill
func is_can_used_skill() -> bool:
	if is_cooldown: return false
	if not is_instance_valid(current_infuse_skill) : return false
	return is_have_mana_for_skill(current_infuse_skill.cost)

func is_have_mana_for_skill(_cost : float) -> bool:
	return player.player_data.current_mana - _cost >= 0

func activate_skill():
	#if have infuse skill
	if is_instance_valid(current_infuse_skill):
		if player.player_data.current_mana - current_infuse_skill.cost < 0: return
		player.player_data.current_mana -= current_infuse_skill.cost
		player.update_hud_display()
		## change player state and use ability
		
		## fire prjectile skill
		var scene :PackedScene = current_infuse_skill.get_scene_async()
		var skill_ins :SkillEmiter = scene.instantiate() as SkillEmiter
		skill_ins.constructor(player.front_point,
		player.front_point.global_position,
		player.direction_holder.scale)
		player.add_sibling(skill_ins)
		skill_ins.active_skill()
		
		is_cooldown = true
		await player.get_tree().create_timer(skill_cooldown).timeout
		is_cooldown = false

func throw_orb():
	if orb_status == OrbStatus.Active:
		## throw orb as prjectile
		var scene :PackedScene = elemental_orb.current_throw_skill.get_scene_async()
		var skill_ins :SkillEmiter = scene.instantiate() as SkillEmiter
		skill_ins.constructor(player.front_point,
		player.front_point.global_position,
		player.direction_holder.scale)
		player.add_sibling(skill_ins)
		skill_ins.active_skill()
		inactive_orb()
#endregion
