class_name SkillContainer extends Resource

@export_file("*.tscn") var path_dir : String
@export var cooldown : float
@export var cost : float
@export var element : ElementData.ElementType

var skill_scene : PackedScene

func load_scene():
	if not is_instance_valid(skill_scene):
		skill_scene = load(path_dir)

func get_scene() -> PackedScene:
	return skill_scene
	
