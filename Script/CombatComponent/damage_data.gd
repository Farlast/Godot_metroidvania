class_name DamageData
extends  Resource

enum TakeDamageRule{NOT_RESET,RESET}
enum DamageMask{ALL,ENEMY,PLAYER}

@export var damage : float
@export var impact : float
@export var knockback : float = 400
@export var sender_position : Vector2
@export var take_damage_rule : TakeDamageRule = TakeDamageRule.NOT_RESET
@export var take_damage_mask : DamageMask = DamageMask.ALL
