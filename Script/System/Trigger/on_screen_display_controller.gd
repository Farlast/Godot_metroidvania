class_name ScreenDisplayController
extends Node2D

@export var screen_notifily : VisibleOnScreenNotifier2D

func _ready():
	screen_notifily.screen_entered.connect(show)
	screen_notifily.screen_exited.connect(hide)
