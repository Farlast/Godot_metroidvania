extends Node2D
##############
# TimeManager
# Autoload
##############
var freeze_slow: float = 0.07
var freeze_duration: float = 0.5

func freeze_time_duration():
	Engine.time_scale = freeze_slow
	await get_tree().create_timer(freeze_duration * freeze_slow).timeout	
	Engine.time_scale = 1

func freeze():
	Engine.time_scale = 0

func unfreeze():
	Engine.time_scale = 1
