extends Node

onready var building = preload("res://example_building/Building.tscn")
var speed = 100
var speed_scale = 100

func _ready():
	var a = building.instance()
	$Map.add_child(a)
	a.global_transform = $Map.global_transform
	pass # Replace with function body.
	
#	$Map.apply_scale(Vector2(0.1,0.1))

func _process(delta):
	if Input.is_action_pressed("ui_left"):
#		print($Node2D.position)
		$Map.translate(Vector2(5,0)*speed*delta)
	if Input.is_action_pressed("ui_right"):
		$Map.translate(Vector2(-5,0)*speed*delta)
	if Input.is_action_pressed("ui_up"):
		$Map.translate(Vector2(0,5)*speed*delta)
	if Input.is_action_pressed("ui_down"):
		$Map.translate(Vector2(0,-5)*speed*delta)
	
	if Input.is_action_just_pressed("map_zoom_in"):
		$Map.apply_scale(Vector2(1,1)*speed_scale*delta)
	if Input.is_action_just_pressed("map_zoom_out"):
		$Map.apply_scale(Vector2(0.5,0.5)*speed_scale*delta)



func _on_VSlider_value_changed(value):
	print(value)
	$Map.scale = Vector2(value, value)
	pass # Replace with function body.
