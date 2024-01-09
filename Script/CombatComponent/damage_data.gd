class_name DamageData
extends  Resource

enum TakeDamageRule{NOT_RESET,RESET}

@export var damage : float
@export var impact : float
@export var knockback : float
@export var sender_position : Vector2
@export var take_damage_rule : TakeDamageRule = TakeDamageRule.NOT_RESET
