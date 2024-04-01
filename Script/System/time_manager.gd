class_name TimeManager extends RefCounted
##############
# TimeManager
# manage game time
##############
var freeze_slow: float = 0.07
var manager : GameManager

func _init(_manager : GameManager):
	manager = _manager

func freeze_time_duration(freeze_duration: float = 0.5):
	manager.game_state = manager.GameState.FREEZE
	Engine.time_scale = freeze_slow
	await manager.get_tree().create_timer(freeze_duration * freeze_slow).timeout	
	Engine.time_scale = 1
	manager.game_state = manager.GameState.GAMEPLAY

func freeze():
	manager.game_state = manager.GameState.FREEZE
	Engine.time_scale = 0

func unfreeze():
	manager.game_state = manager.GameState.GAMEPLAY
	Engine.time_scale = 1
