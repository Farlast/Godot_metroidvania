class_name DamageData
extends  Resource

enum TakeDamageRule {NOT_RESET,RESET}
enum DamageMask {ALL,ENEMY,PLAYER}

@export var damage : float
@export var impact : float
@export var take_damage_rule : TakeDamageRule = TakeDamageRule.NOT_RESET
@export var take_damage_mask : DamageMask = DamageMask.ALL
@export var element : ElementData.ElementType

var attacker_id : int
var sender_position : Vector2
