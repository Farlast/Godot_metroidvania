class_name SkillContainer extends Resource

signal resource_load_completed()
signal thread_finished(result)

@export_file("*.tscn") var path_dir : String
@export var cooldown : float
@export var cost : float
@export var element : ElementData.ElementType

var skill_scene : PackedScene

func request_load_scene():
	if not is_instance_valid(skill_scene):
		ResourceLoader.load_threaded_request(path_dir)

func get_scene_async() -> PackedScene:
	if is_instance_valid(skill_scene):
		return skill_scene
	else:
		skill_scene = ResourceLoader.load_threaded_get(path_dir)
		return skill_scene
