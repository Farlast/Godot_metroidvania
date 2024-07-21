extends Node2D

const WATER_SPRING = preload("res://Scenes/Water/water_spring.tscn")
@onready var water_polygon :Polygon2D= $Polygon2D
@onready var water_body_area :Area2D= $Area2D
@onready var collision_shape_2d :CollisionShape2D= $Area2D/CollisionShape2D

@export var distance_between_spring : float = 35
@export var spring_amount : int = 3
@export_group("confix")
@export var stiffness : float = 0.015
@export var damping : float = 0.03
@export var spread : float = 0.003
@export_group("art")
@export var depth : float = 100

var target_height : float
var bottom : float
var spring_array : Array = []
var left_deltas : Array = []
var right_deltas : Array = []

var first_index :int = 0
var last_index :int
var water_polygon_points:PackedVector2Array
var surface_point: Array = []

func _ready()->void:
	target_height = 0
	bottom = target_height + depth
	for i in range(spring_amount):
		var x_position :float= distance_between_spring * i
		var water_ins := WATER_SPRING.instantiate()
		add_child(water_ins)
		spring_array.append(water_ins)
		water_ins.initalize(x_position,i)
		water_ins.set_collision_width(distance_between_spring)
		water_ins.splash.connect(splash)
	
	for i in range(spring_array.size()):
		left_deltas.append(0)
		right_deltas.append(0)
	
	for i in range(spring_array.size()):
		surface_point.append(spring_array[i].position)
	
	first_index = 0
	last_index = surface_point.size() -1
	water_polygon_points = surface_point
	
	water_polygon_points.append(Vector2(surface_point[last_index].x,bottom))
	water_polygon_points.append(Vector2(surface_point[first_index].x,bottom))
	water_polygon_points = PackedVector2Array(water_polygon_points)
	water_polygon.set_polygon(water_polygon_points)
	
	var total_length := distance_between_spring * (spring_amount-1)
	var rect_position :Vector2= Vector2(total_length/2,depth/2)
	var rect_size :Vector2= Vector2(total_length,depth)
	collision_shape_2d.shape.size = rect_size
	water_body_area.position = rect_position

func _physics_process(_delta:float)->void:
	for i:WaterSpring in spring_array:
		i.wave_update(stiffness,damping)
	for i in range(spring_array.size()):
		if i > 0:
			left_deltas[i] = spread * (spring_array[i].height - spring_array[i-1].height)
			spring_array[i-1].velocity += left_deltas[i]
		if i < spring_array.size()-1:
			right_deltas[i] = spread * (spring_array[i].height - spring_array[i+1].height)
			spring_array[i+1].velocity += right_deltas[i]
	drawn_water_body()

func splash(index:int,speed:float)->void:
	if index > 0 and index < spring_array.size():
		spring_array[index].velocity += speed

func drawn_water_body()->void:
	water_polygon_points = water_polygon.polygon
	for i in range(spring_array.size()):
		water_polygon_points.set(i,spring_array[i].position)
		water_polygon.polygon = water_polygon_points
	water_polygon.queue_redraw()
