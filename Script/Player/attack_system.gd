class_name AttackSystem
extends Node

signal allow_skip_animation
signal next_combo_state
signal enable_hitbox
signal disable_hitbox
signal iframe_start
signal iframe_end

@export var attack_speed : float = 0.15

func next_combo()->void:
	next_combo_state.emit()
func skip_animation_window()->void:
	allow_skip_animation.emit()
func set_enable_hitbox()->void:
	enable_hitbox.emit()
func set_disable_hitbox()->void:
	disable_hitbox.emit()
func start_iframe()->void:
	iframe_start.emit()
func stop_iframe()->void:
	iframe_end.emit()
