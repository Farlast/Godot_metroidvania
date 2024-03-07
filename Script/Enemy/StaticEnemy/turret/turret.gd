class_name Turret
extends StaticEnemy

@onready var attack_box : CollisionShape2D = $AttackBox/CollisionShape2D
@onready var attack_point : Node2D = $AttackPoint

@export var bullet : PackedScene = preload("res://Scenes/Effect/bullet_acid.tscn")
@export var start_delay : float
@export var fire_rate : float = 0.5

var fire_timer : float = 0
var attack_ready : bool = false

enum STATE{
	Idle,
	Attack
}
var current_state : STATE

func _ready():
	super._ready()
	current_state = STATE.Idle

func _process(delta):
	flash_on_hit(delta)
	if start_delay > 0:
		start_delay -= delta
		return
	state_calculate(delta)

func take_damage(damage : DamageData):
	super.take_damage(damage)
	flashing = true
	
func dead():
	attack_box.set_deferred("disabled",true)
	super.dead()

func state_calculate(delta):
	match current_state:
		STATE.Idle:
			on_idle(delta)
		STATE.Attack:
			fire_bullet(delta)

func on_idle(delta):
	if attack_ready:
		attack_ready = false
		fire_timer = 0
		current_state = STATE.Attack
	else:
		fire_timer += delta
	
	if fire_timer >= fire_rate:
		attack_ready = true

func fire_bullet(_delta):
	current_state = STATE.Idle
	$AnimationPlayer.play("attack")
	var bullet_ins := bullet.instantiate() as Bullet
	bullet_ins.direction = Vector2(0,1)
	bullet_ins.speed = 900
	add_child(bullet_ins)
	bullet_ins.global_position = attack_point.global_position
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("idle")
	
