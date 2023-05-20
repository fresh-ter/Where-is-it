extends Node2D

onready var camera := $Camera2D
onready var ui := $Camera2D/CanvasLayer/UI

#onready var building = preload("res://example_building/Building.tscn")
const FILE_NAME = "res://example_building/building.json"

var speed = 100
var speed_scale = 100
var building_data: Dictionary

var _previousPosition: Vector2 = Vector2(0, 0);

var current_level = 1

func _ready():
#	var a = building.instance()
#	$Map.add_child(a)
#	a.global_transform = $Map.global_transform
	test()
	get_building_data()
	print(building_data)
	
	Events.connect("zoom_changed", self, "on_zoom_changed")
	Events.connect("level_selected", self, "on_level_selected")
	Events.connect("mouse_dragging", self, "on_mouse_dragging")
	Events.connect("button_search_pressed", self, "on_button_search_pressed")
	
#	Events.emit_signal("label_update", "Map - "+str(current_level))
	ui.level_update(current_level)
	
#	$Camera2D/CanvasLayer/UI/MenuButton.get_popup().add_item("Legend")
#	$Camera2D/CanvasLayer/UI/MenuButton.get_popup().add_item("Info")
	$Camera2D/CanvasLayer/UI/MenuButton.get_popup().connect('id_pressed', self, 'on_menu_id_pressed')
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

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			# zoom in
			if event.button_index == BUTTON_WHEEL_UP:
				print("up")
				# call the zoom function
			# zoom out
			if event.button_index == BUTTON_WHEEL_DOWN:
				print("down")



func test():
#	print($Building.get_child_count())
#	print($Building.get_children())
	
	for level in $Building.get_children():
		for area in level.get_node("Areas").get_children():
			print(area)
			area.get_node("Area2D").connect('input_event', self, 'test_slot', [area.name])
		var level_id = level.name.right(1)
		print(level_id)
#		Events.emit_signal("start_add_new_level", level_id)
		ui.start_add_new_level(level_id)
		var s = "test"
		print(s.right(1))
		print(level.visible)
		level.visible = false
	
	$Building.get_children()[0].visible = true

func test_slot(viewport: Node, event: InputEvent, shape_idx: int, name: String):
	if event is InputEventMouseButton:
		if event.pressed:
			var t
			for level in $Building.get_children():
				if level.name.right(1) == str(current_level):
					t = level.find_node(name).find_node('CollisionShape2D')
					break
			
			var id = name
			id.erase(0,1)
			id = int(id)
			
			print("Test: " + name + '  |  ', id)
			
			var t2 = $Building.to_global(t.position)
			print(event.position)
			
			print(t2)
			
			$Camera2D.position = to_global(t.position)
			print($Camera2D.position)
			
			var data = building_data["levels"][current_level-1]['areas'][id]
			$Camera2D/CanvasLayer/UI/ColorRect/RichTextLabel.text = "Name: " + data['name']
			
			



func on_zoom_changed(value):
	print(value)
	$Camera2D.zoom = Vector2(value, value)
#	$Building.scale = Vector2(value, value)
	pass # Replace with function body.

func on_menu_id_pressed(id: int):
	print("Menu", id)
	
	if id == 0:
		var vbox = $Camera2D/CanvasLayer/UI/WindowDialog/VBoxContainer
		
		for x in building_data["types_area"]:
			var new_hbox = $Camera2D/CanvasLayer/UI/WindowDialog/VBoxContainer/HBoxContainer.duplicate()
			new_hbox.get_node("Label").text = x["type"]
			new_hbox.get_node("ColorRect").color = Color(x["color"])
			
			vbox.add_child(new_hbox)
		
		$Camera2D/CanvasLayer/UI/WindowDialog/VBoxContainer/HBoxContainer.visible = false
			
		$Camera2D/CanvasLayer/UI/WindowDialog.popup_centered()

func on_level_selected(level_id):
	var i := 0
	for level in $Building.get_children():
		level.visible = false
	
	for level in $Building.get_children():
		if level.name.right(1) == str(level_id):
			print("hahahah")
			level.visible = true
			current_level = level_id
			print("current:", current_level)
			ui.level_update(current_level)

func on_mouse_dragging(p):
	print("old p: ", _previousPosition)
	print("new p: ", p)
	
#	camera.position = p
#	camera.position += (_previousPosition - p)
	_previousPosition = p

func on_button_search_pressed(text):
	print(text)
	
	print(building_data)
	
	for area in building_data["levels"][current_level-1]['areas']:
		if area['name'] == text:
			var t
			var name = "A"+str(area["id"])
			for level in $Building.get_children():
				if level.name.right(1) == str(current_level):
					t = level.find_node(name).find_node('CollisionShape2D')
					break
			
			var id = name
			id.erase(0,1)
			id = int(id)
			
			print("Test: " + name + '  |  ', id)
			
			var t2 = $Building.to_global(t.position)
			print(t2)
			
			$Camera2D.position = to_global(t.position)
			print($Camera2D.position)
			
			var data = building_data["levels"][current_level-1]['areas'][id]
			$Camera2D/CanvasLayer/UI/ColorRect/RichTextLabel.text = "Name: " + data['name']
			
		print(area['name'])
