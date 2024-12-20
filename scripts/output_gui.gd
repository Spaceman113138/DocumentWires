extends GridContainer
class_name OutputGUI


var output: OutputPlaceholder


func setOutput(wireOutput: OutputPlaceholder) -> void:
	output = wireOutput
	get_node("xEdit").text = str(output.global_position.x)
	get_node("yEdit").text = str(-output.global_position.y)
	get_node("wireEdit").text = str(output.wireSize)
	get_node("ColorPickerButton").color = output.get_node("base").modulate
	get_node("NameEdit").text = output.name
	get_node("typeEdit").text = output.type

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_x_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		output.position.x = new_text.to_float()


func _on_y_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		output.position.y = -new_text.to_float()


func _on_wire_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		output.wireSize = new_text.to_int()


func _on_color_picker_button_color_changed(color: Color) -> void:
	output.color = color


func _on_type_edit_text_changed(new_text: String) -> void:
	output.type = new_text


func _on_delete_pressed() -> void:
	output.queue_free()
	queue_free()


func _on_name_edit_text_changed(new_text: String) -> void:
	output.name = new_text
