extends Control
class_name DeviceEditGUI

@onready var creatorNode: Node2D = get_tree().root.get_node("deviceCreator")

var offset: float = 20
var width: float = 200
var height: float = 300

var toClear = []

const outputPlaceholder: PackedScene = preload("res://scenes/output_placeholder.tscn")
const outputGUI:PackedScene = preload("res://scenes/output_gui.tscn")
const inputPlaceholder: PackedScene = preload("res://scenes/input_placeholder.tscn")
const inputGUI: PackedScene = preload("res://scenes/input_gui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reload()


func clear() -> void:
	for node in toClear:
		node.queue_free()
	toClear = []

func reload() -> void:
	get_node("ScrollContainer/VBoxContainer/GridContainer/color button").color = creatorNode.get_child(0).get_node("base").modulate
	width = creatorNode.get_child(0).get_node("base").mesh.size.x
	height = creatorNode.get_child(0).get_node("base").mesh.size.y
	get_node("ScrollContainer/VBoxContainer/GridContainer/widthEdit").text = str(width)
	get_node("ScrollContainer/VBoxContainer/GridContainer/heightEdit").text = str(height)
	offset = creatorNode.get_child(0).get_node("highlight").mesh.size.y - height
	get_node("ScrollContainer/VBoxContainer/GridContainer/highlightght edit").text = str(offset)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_width_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		width = new_text.to_float()
		creatorNode.get_child(0).get_node("base").mesh.size.x = abs(width)
		creatorNode.get_child(0).get_node("highlight").mesh.size.x = abs(width) + offset/2
		creatorNode.get_child(0).get_node("CollisionShape2D").shape.size.x = abs(width) + offset/2.0


func _on_height_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		height = new_text.to_float()
		creatorNode.get_child(0).get_node("base").mesh.size.y = abs(height)
		creatorNode.get_child(0).get_node("highlight").mesh.size.y = abs(height) + offset/2
		creatorNode.get_child(0).get_node("CollisionShape2D").shape.size.y = abs(height) + offset/2.0


func _on_highlightght_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		offset = new_text.to_float()
		creatorNode.get_child(0).get_node("highlight").mesh.size = Vector2(width, height) + Vector2(offset/2.0, offset/2.0)
		creatorNode.get_child(0).get_node("CollisionShape2D").shape.size = Vector2(width, height) + Vector2(offset/2.0, offset/2.0)


func _on_color_button_color_changed(color: Color) -> void:
	creatorNode.get_child(0).get_node("base").modulate = color


func _on_add_output_pressed() -> void:
	var node: OutputPlaceholder = outputPlaceholder.instantiate()
	#node.global_position = get_tree().root.get_node("deviceCreator/Camera2D").global_position
	var gui: OutputGUI = outputGUI.instantiate()
	gui.setOutput(node)
	get_node("ScrollContainer/VBoxContainer/HSeparator").add_sibling(gui)
	get_tree().root.get_node("deviceCreator").get_child(0).get_node("outputs").add_child(node)
	node.set_owner(node.get_parent())
	toClear.append(gui)


func _on_add_input_pressed() -> void:
	var node: InputPlaceholder = inputPlaceholder.instantiate()
	var gui: InputGUI = inputGUI.instantiate()
	gui.setInput(node)
	get_node("ScrollContainer/VBoxContainer/HSeparator2").add_sibling(gui)
	get_tree().root.get_node("deviceCreator").get_child(0).get_node("inputs").add_child(node)
	node.set_owner(node.get_parent())
	toClear.append(gui)
