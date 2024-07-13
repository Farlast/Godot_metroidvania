extends Node2D

@onready var ember : CPUParticles2D = $Ember
@onready var wet : CPUParticles2D = $Wet
@onready var attack_area : CollisionShape2D = $AttackBox/CollisionShape2D
@onready var collision : CollisionShape2D = $CollisionShape2D

func take_damage(damage_data : DamageData):
	if damage_data.element == ElementData.ElementType.WATER:
		#putout fire
		ember.set_deferred("emitting",false)
		wet.set_deferred("emitting",true)
		attack_area.set_deferred("disabled",true)
		collision.set_deferred("disabled",true)
