class_name SkillContainer extends Resource

@export_file("*.tscn") var path_dir : String
@export var cooldown : float
@export var cost : float
@export var cast_time : float
@export var animation_name : String = "sample"
@export var icon : Texture2D
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

func active_skill(_skill_system : SkillSystem):
	pass
