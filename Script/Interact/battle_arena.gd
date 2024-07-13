extends Node
### Lockdoor on first time enter the area
### spawn an enemies at random position
### if all enemy killed open lockdoor and mark cleared.
signal trigger_door

@export var enemies_to_spawn : PackedScene
@onready var spawn_point_group = $SpawnPoints
@onready var enemies = $Enemies

var spawn_points : Array = []
var cleared : bool = false
var actived :bool = false

#track enemy for end the challange
var enemy_count : int

func  _ready():
	for node in spawn_point_group.get_children():
		if node is Node2D:
			spawn_points.append(node)

func spawn_fix_enemy(spawn_node: EnemySpawnPoint):
	var obj = spawn_node.spawn(enemies)
	if obj.has_signal("on_dead"):
		enemy_count += 1
		obj.on_dead.connect(enemy_killed)

# Lockdoor on first time enter the area
func _on_body_entered(_body):
	if actived: return
	for spawn_node:EnemySpawnPoint in spawn_points:
		spawn_fix_enemy(spawn_node)
	actived = true
	trigger_door.emit()

func enemy_killed():
	enemy_count -= 1
	if enemy_count <= 0:
		trigger_door.emit()
