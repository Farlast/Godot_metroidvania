class_name EnemySpawnPoint extends Node2D 

@export var enemy_scene : PackedScene
@export var auto_spawn : bool

func _ready()->void:
	if auto_spawn:
		spawn(self,null)

func spawn(parent : Node,target : Node2D)-> Enemy:
	var obj :Enemy= enemy_scene.instantiate() as Enemy
	obj.position = global_position
	obj.target = target
	parent.call_deferred("add_child",obj)
	return obj
