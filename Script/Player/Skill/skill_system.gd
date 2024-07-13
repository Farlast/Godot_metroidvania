class_name SkillSystem
extends Node

### ============
### Manage absorb and infuse.
### send absorb command and get object
### press absorb again will throw and lose object
### press infuse will get skill for later use
### ============
signal got_element(element)

@onready var grab_ray : RayCast2D = $"../Directions/Element_ray"
@onready var familiar_scene : PackedScene = preload("res://Scenes/Player/familiar.tscn")
var pickup_area : Area2D
@export var ui_event : CustomEventChannel

var player : Player
var is_cooldown : bool = false

var familiar : Familiar
var current_skill : SkillContainer

func setup(ref_player : Player):
	player = ref_player
	familiar = familiar_scene.instantiate() as Familiar
	familiar.defualt_target = player.orb_anchor
	familiar.lerp_target = player.orb_anchor
	player.add_sibling.call_deferred(familiar)

#region Familiar
func command_familiar():
	### grab object or throw it if object in hand
	match familiar.hand_status:
		familiar.Hand.EMPTY:
			if grab_ray.is_colliding():
				var coll = grab_ray.get_collider()
				if coll is GrabbableHost:
					if coll.can_havest():
						familiar.on_get_object(coll)
						familiar.global_position = grab_ray.get_collision_point()
		familiar.Hand.CARRIED:
			familiar.throw(self)

#endregion
#region skill
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
		var timer = 0
		while timer < current_skill.cooldown:
			await get_tree().create_timer(0.05).timeout
			timer += 0.05
			ui_event.float_event_sended.emit(timer/current_skill.cooldown)
		is_cooldown = false

#endregion
