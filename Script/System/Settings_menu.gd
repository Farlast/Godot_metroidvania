extends CanvasLayer

##############
# Autoload
##############

@onready var fullscreen_btt : CheckButton = $Margin/VBoxContainer/TabContainer/Display/Fullscreen


func _ready():
	
	hide()
	set_default()

func set_default():
	fullscreen_btt.set_pressed_no_signal(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)

func  show_Settings():
	fullscreen_btt.grab_focus()
	TimeManager.freeze()
	show()

func _on_fullscreen_toggled(button_pressed):
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else: 
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_back_pressed():
	TimeManager.unfreeze()
	hide()
