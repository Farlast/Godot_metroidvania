extends Button

@export_file("*.tscn") var next_scene_file : String

func _ready()->void:
	pressed.connect(load_to_scene)

func load_to_scene()->void:
	SceneManager.change_scene_by_name(next_scene_file)
