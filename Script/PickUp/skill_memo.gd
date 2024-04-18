class_name SkillMemo extends Area2D

@onready var stay_effect : CPUParticles2D = $IdleParticles
@onready var pickup_effect : CPUParticles2D = $PickupParticles
@export var skill : SkillContainer

func pickup():
	stay_effect.emitting = false
	pickup_effect.restart()
	await get_tree().create_timer(0.5).timeout
	queue_free()
