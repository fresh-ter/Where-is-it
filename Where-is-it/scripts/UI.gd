extends Control

onready var label := $Label
onready var level_button := $LevelButton
onready var zoom_slider := $VSlider
onready var search_button := $SearchButton
onready var search_lineedit := $LineEdit

var dragging := false


func _ready():
#	Events.connect("start_add_new_level", self, "on_add_new_level")
#	Events.connect("label_update", self, "on_label_update")
	level_button.get_popup().connect('id_pressed', self, 'on_levelmenu_id_pressed')


func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			print("button_index:", event.button_index)
			print(zoom_slider.value)
			if event.button_index == BUTTON_WHEEL_UP:
				print("up")
#				if zoom_slider.value+zoom_slider.step
				zoom_slider.value -= zoom_slider.step
				# call the zoom function
			# zoom out
			if event.button_index == BUTTON_WHEEL_DOWN:
				print("down")
				zoom_slider.value += zoom_slider.step
				
			if event.button_index == BUTTON_LEFT:
				dragging = true
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		var p = get_global_mouse_position()
		print("position", p)
		Events.emit_signal("mouse_dragging", p)



func _on_VSlider_value_changed(value):
#	print(value)
	Events.emit_signal("zoom_changed", value)
	pass # Replace with function body.

func start_add_new_level(level_id):
	print("add"+level_id)
	level_button.get_popup().add_item(level_id)

func level_update(level_id):
	print("label - ", level_id)
#	label.text = name
	level_button.text = str(level_id)

func on_levelmenu_id_pressed(id):
	id += 1;
	print(id)
	Events.emit_signal("level_selected", id)


func _on_SearchButton_pressed():
	Events.emit_signal("button_search_pressed", search_lineedit.text)
