extends Node

#onready var building = preload("res://example_building/Building.tscn")
var speed = 100
var speed_scale = 100

func _ready():
#	var a = building.instance()
#	$Map.add_child(a)
#	a.global_transform = $Map.global_transform
	test()
	pass # Replace with function body.
	
#	$Map.apply_scale(Vector2(0.1,0.1))

func _process(delta):
	if Input.is_action_pressed("ui_left"):
#		print($Node2D.position)
		$Camera2D.translate(Vector2(-5,0)*speed*delta)
	if Input.is_action_pressed("ui_right"):
		$Camera2D.translate(Vector2(5,0)*speed*delta)
	if Input.is_action_pressed("ui_up"):
		$Camera2D.translate(Vector2(0,-5)*speed*delta)
	if Input.is_action_pressed("ui_down"):
		$Camera2D.translate(Vector2(0,5)*speed*delta)
	
#	if Input.is_action_just_pressed("map_zoom_in"):
#		$Building.apply_scale(Vector2(1,1)*speed_scale*delta)
#	if Input.is_action_just_pressed("map_zoom_out"):
#		$Building.apply_scale(Vector2(0.5,0.5)*speed_scale*delta)


func test():
#	print($Building.get_child_count())
#	print($Building.get_children())
	
	for level in $Building.get_children():
		for area in level.get_node("Areas").get_children():
			print(area)
			area.get_node("Area2D").connect('input_event', self, 'test_slot', [area.name])

func test_slot(viewport: Node, event: InputEvent, shape_idx: int, name: String):
	if event is InputEventMouseButton:
		if event.pressed:
			print("Test: " + name)



func _on_VSlider_value_changed(value):
	print(value)
	$Building.scale = Vector2(value, value)
	pass # Replace with function body.
