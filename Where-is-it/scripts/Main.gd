extends Node2D

#onready var building = preload("res://example_building/Building.tscn")
const FILE_NAME = "res://example_building/building.json"

var speed = 100
var speed_scale = 100
var building_data: Dictionary

func _ready():
#	var a = building.instance()
#	$Map.add_child(a)
#	a.global_transform = $Map.global_transform
	test()
	get_building_data()
	print(building_data)
	$Camera2D/CanvasLayer/UI/MenuButton.get_popup().add_item("Legends")
	pass # Replace with function body.
	
#	$Map.apply_scale(Vector2(0.1,0.1))


func get_building_data():
	var file = File.new()
	file.open(FILE_NAME, File.READ)
	building_data = parse_json(file.get_as_text())
	file.close()


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
			var t = $Building.find_node(name).find_node('CollisionShape2D')
			
			var id = name
			id.erase(0,1)
			id = int(id)
			
			print("Test: " + name + '  |  ', id)
			
			var t2 = $Building.to_global(t.position)
			print(event.position)
			
			print(t2)
			
			$Camera2D.position = to_global(t.position)
			print($Camera2D.position)
			
			var data = building_data["levels"][0]['areas'][id]
			$Camera2D/CanvasLayer/UI/ColorRect/RichTextLabel.text = "Name: " + data['name']
			
			



func _on_VSlider_value_changed(value):
	print(value)
	$Camera2D.zoom = Vector2(value, value)
#	$Building.scale = Vector2(value, value)
	pass # Replace with function body.
