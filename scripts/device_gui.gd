extends Control
class_name DeviceGUI

var selectedDevice: Device

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func selectDevice(device: Device) -> void:
	selectedDevice =  device
	get_node("ScrollContainer/VBoxContainer").visible = true
	get_node("ScrollContainer/VBoxContainer/Device Name/TextEdit").text = device.name
	get_node("ScrollContainer/VBoxContainer/Position Container/Rot Edit").text = str(device.rotation_degrees)
	
	if device.canEnabled:
		get_node("ScrollContainer/VBoxContainer/Position Container/CAN Label").visible = true
		get_node("ScrollContainer/VBoxContainer/Position Container/CAN Edit").visible = true
		get_node("ScrollContainer/VBoxContainer/Position Container/CAN Edit").text = str(device.canID)
	else:
		get_node("ScrollContainer/VBoxContainer/Position Container/CAN Label").visible = false
		get_node("ScrollContainer/VBoxContainer/Position Container/CAN Edit").visible = false

func deSelect() -> void:
	get_node("ScrollContainer/VBoxContainer").visible = false


func _on_rot_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		selectedDevice.rotation_degrees = new_text.to_float()
		selectedDevice.moveWires(true)


func _on_can_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		selectedDevice.canID = new_text.to_int()


func _on_text_edit_text_changed(new_text: String) -> void:
	selectedDevice.name = new_text
