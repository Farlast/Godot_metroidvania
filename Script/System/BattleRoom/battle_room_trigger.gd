extends TriggerSwitch

@onready var area : Area2D = $Area2D

@export_category("Exit condition")
@export var on_all_enemy_dead : bool = true
@export var enemy : Node2D

var cleared : bool = false

func _ready():
	area.body_entered.connect(on_entered)
	if enemy.has_signal("on_dead"):
		enemy.on_dead.connect(open_gate)

func on_entered(_body):
	if cleared : return
	switch_triggered.emit()
	cleared = true

func open_gate():
	switch_triggered.emit()
