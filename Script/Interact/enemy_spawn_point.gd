class_name EnemySpawnPoint extends Node2D 

@export var enemy_scene : PackedScene
@export var auto_spawn : bool

func _ready():
	if auto_spawn:
		spawn(self)

func spawn(parent : Node)-> Enemy:
	var obj := enemy_scene.instantiate()
	obj.position = global_position
	parent.call_deferred("add_child",obj)
	return obj
