class_name SingleBullet
extends SkillContainer

@export var speed : float = 800
@export var damage_data : DamageData
@export_group("Audio")
@export var start_audio : AudioStream
@export var running_audio : AudioStream
@export var end_audio : AudioStream

func fire_bullet(spawn_point : Node2D,direction : Vector2,parent_node:Node)->void:
	var bullet_ins := get_scene_async().instantiate() as Bullet
	bullet_ins.direction = direction
	bullet_ins.rotation = atan2(direction.x,-direction.y)
	bullet_ins.position = spawn_point.global_position
	bullet_ins.damage_data = damage_data
	bullet_ins.speed = speed
	bullet_ins.set_audios(start_audio,running_audio,end_audio)
	parent_node.add_sibling.call_deferred(bullet_ins)
	

