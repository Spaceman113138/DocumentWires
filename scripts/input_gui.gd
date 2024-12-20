extends GridContainer
class_name InputGUI



var input: InputPlaceholder


func setInput(wireOutput: InputPlaceholder) -> void:
	input = wireOutput
	get_node("xEdit").text = str(input.global_position.x)
	get_node("yEdit").text = str(-input.global_position.y)
	get_node("wireMinEdit").text = str(input.wireSizeMin)
	get_node("wireMaxEdit").text = str(input.wireSizeMax)
	get_node("ColorPickerButton").color = input.get_node("body").modulate
	get_node("NameEdit").text = input.name
	get_node("typeEdit").text = input.type

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_x_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		input.position.x = new_text.to_float()


func _on_y_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		input.position.y = -new_text.to_float()


func _on_color_picker_button_color_changed(color: Color) -> void:
	input.color = color


func _on_type_edit_text_changed(new_text: String) -> void:
	input.type = new_text


func _on_delete_pressed() -> void:
	input.queue_free()
	queue_free()


func _on_wire_max_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		if new_text.to_int() >= input.wireSizeMin:
			input.wireSizeMax = new_text.to_int()


func _on_wire_min_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		if new_text.to_int() <= input.wireSizeMax:
			input.wireSizeMin = new_text.to_int()


func _on_name_edit_text_changed(new_text: String) -> void:
	input.name = new_text
