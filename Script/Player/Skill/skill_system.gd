class_name SkillSystem
extends Node

### ============
### Lantern and skill manager
### ============

@onready var grab_ray : RayCast2D = $"../Directions/Element_ray"
@onready var familiar_scene : PackedScene = preload("res://Scenes/Player/familiar.tscn")

@export_group("Projectile skill")
@export var ui_event : CustomEventChannel
@export var current_skill : SkillContainer

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
	return false

func command_familiar()->void:
	### grab object or throw it if object in hand
	match familiar.hand_status:
		familiar.Hand.EMPTY:
			if grab_ray.is_colliding():
				var coll:= grab_ray.get_collider()
				if coll is GrabbableHost:
					if coll.can_havest():
						familiar.on_get_object(coll)
						familiar.global_position = grab_ray.get_collision_point()
		familiar.Hand.CARRIED:
			familiar.throw(self)

#endregion
#region skill
func is_can_use_skill(event : InputEvent) -> bool:
	if not event.is_action_pressed("action_2"): return false
	#if not player.player_data.is_abilitie_unlock("command"): return false
	if is_cooldown: return false
	if not is_instance_valid(current_skill) : return false
	#is have mana for skill
	return player.player_data.current_mana - current_skill.cost>= 0

func activate_skill()->void:
	#if have infuse skill
	if is_instance_valid(current_skill):
		if player.player_data.current_mana - current_skill.cost < 0: return
		player.player_data.current_mana -= current_skill.cost
		player.update_hud_display()
		## change player state and use ability
		current_skill.active_skill(self)
		
		is_cooldown = true
		var timer:float = 0
		while timer < current_skill.cooldown:
			await get_tree().create_timer(0.05).timeout
			timer += 0.05
			ui_event.float_event_sended.emit(timer/current_skill.cooldown)
		is_cooldown = false

#endregion
