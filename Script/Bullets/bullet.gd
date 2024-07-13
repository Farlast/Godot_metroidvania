extends Area2D
class_name Bullet

@onready var attack_box_col : CollisionShape2D = $AttackBox/CollisionShape2D
@onready var attack_box : AttackBox = $AttackBox
@export var damage_data : DamageData
@export var piercing : bool = false
@export var time_to_free : float = 1

var direction : Vector2
var speed : float = 800
var stop : bool

func _ready():
	stop = false
	attack_box.damage_data = damage_data
	body_entered.connect(grounded)

func setup(_direction : Vector2,_damage_data : DamageData):
	direction = _direction
	attack_box.damage_data = _damage_data

func take_damage(_damage:DamageData):
	on_free()

func attack_feedback(_hurtBox):
	if not piercing:
		on_free()

func grounded(_body):
	on_free()

func _physics_process(delta):
	if not stop:
		global_position += direction * (speed * delta)
	
func on_free():
	stop = true
	attack_box_col.set_deferred("disabled",true)
	$AnimationPlayer.play("destory")
	await get_tree().create_timer(time_to_free).timeout
	queue_free()
