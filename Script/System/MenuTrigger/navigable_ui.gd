class_name CanvasUI extends CanvasLayer
### Base class ####
### remember previous ui before and button it previous select before close
### work for ui that not replece main scene (overlay)

@export var defualt_focus : Control

var last_object_select : Control
var previous_panel : CanvasUI
var is_focus : bool

func open(_previous_panel: CanvasUI)->void:
	show()
	GameManager.time_manager.freeze()
	GameManager.game_state = GameManager.GameState.FREEZE
	set_select_button()
	is_focus = true
	if _previous_panel != null:
		previous_panel = _previous_panel

func close()->void:
	hide()
	GameManager.time_manager.unfreeze()
	GameManager.game_state = GameManager.GameState.GAMEPLAY
	last_object_select = get_viewport().gui_get_focus_owner()
	is_focus = false

func back_to_previous()->void:
	hide()
	GameManager.time_manager.unfreeze()
	GameManager.game_state = GameManager.GameState.GAMEPLAY
	last_object_select = get_viewport().gui_get_focus_owner()
	is_focus = false
	if previous_panel != null:
		previous_panel.open(self)
		previous_panel = null

func set_select_button()->void:
	if last_object_select != null:
		last_object_select.grab_focus()
	elif defualt_focus != null:
		defualt_focus.grab_focus()
