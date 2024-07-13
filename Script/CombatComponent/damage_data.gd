class_name DamageData
extends  Resource

enum TakeDamageRule {NOT_RESET,RESET}
enum DamageMask {ALL,ENEMY,PLAYER}
enum KnockBackForce {NONE,LOW,MID,HEAVY}

@export var damage : float : 
	get:
		return damage * (damage_multiply + 1)

@export var impact : float : # damage to poise bar
	get:
		return impact + impact_add

@export var knockback_force : KnockBackForce = KnockBackForce.NONE
@export var element : ElementData.ElementType
@export_group("Rule")
@export var take_damage_rule : TakeDamageRule = TakeDamageRule.NOT_RESET
@export var take_damage_mask : DamageMask = DamageMask.ALL

var attacker_id : int
var sender_position : Vector2
var damage_multiply : float
var impact_add : float

func add(data:DamageData)->void:
	damage_multiply = data.damage
	impact = data.impact
	knockback_force = data.knockback_force
	element = data.element
