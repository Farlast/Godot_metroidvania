extends Enemy
class_name EldritchWorm

@export_group("RayCast2D")
@export var front_ray : RayCast2D
@export var room_trigger : TriggerSwitch

var target : Node2D

var stage_2: bool = false
var data : NodeSaveData
#region Damage
func _ready():
	shader = $Direction/Sprite2D.material as ShaderMaterial
	
	var id = GameManager.get_object_id(self)
	data = NodeSaveData.new()
	data.id = id
	data.status = false
	
	if GameManager.is_object_stored(id):
		queue_free()

func take_damage(damage_data : DamageData):
	health -= damage_data.damage
	hit_effect.rotation = get_angle_to(damage_data.sender_position) + PI
	hit_effect.restart()
	slash_effect.restart()
	hit_sound.play()
	flash_on_hit()
	
	if not stage_2 and health < 20:
		stage_2 = true
	
	if health <= 0:
		dead()
	else :
		get_hit_direction = (damage_data.sender_position - global_position).normalized()

func dead():
	data.status = true
	GameManager.store_object(data.id,data)
	dead_sound.play()
	dead_particle.restart()
	pulse_particle.restart()
	set_process(false)
	set_physics_process(false)
	state_machine.set_process(false)
	state_machine.set_physics_process(false)
	hitbox.set_deferred("disabled",true)
	hurtbox.set_deferred("disabled",true)
	collion.set_deferred("disabled",true)
	on_dead.emit()
	room_trigger.switch_triggered.emit()
	state_machine.current_state.transition.emit(state_machine.current_state,"dead")
	animator.play("dead")
	await animator.animation_finished
	await get_tree().create_timer(1.5).timeout
	queue_free()
	
func flash_on_hit():
	shader.set_shader_parameter("active",true)
	await get_tree().create_timer(0.2).timeout
	shader.set_shader_parameter("active",false)
#endregion

