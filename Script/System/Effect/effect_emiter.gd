class_name EffectEmiter extends Node2D

var gpu_effects : Array[GPUParticles2D]
var cpu_effects : Array[CPUParticles2D]

func _ready():
	gpu_effects.clear()
	cpu_effects.clear()
	for child in get_children():
		if child is GPUParticles2D:
			gpu_effects.append(child)
		if child is CPUParticles2D:
			cpu_effects.append(child)

func restart_all():
	if gpu_effects.size() > 0:
		for effect in gpu_effects:
			effect.restart()
	if cpu_effects.size() > 0:
		for effect in cpu_effects:
			effect.restart()
