extends Button
class_name DeviceButton


var deviceName: String
var deviceScene: PackedScene


func _init(DeviceName: String, DeviceScene: PackedScene) -> void:
	deviceName = DeviceName
	deviceScene = DeviceScene
	
	text = deviceName
	alignment = HORIZONTAL_ALIGNMENT_CENTER
	custom_minimum_size.x = 200
	action_mode = BaseButton.ACTION_MODE_BUTTON_PRESS

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _pressed() -> void:
	var camera: worldCamera = get_tree().root.get_node("world/worldCamera")
	var offset = camera.global_position
	var deviceNode: Device = deviceScene.instantiate()
	deviceNode.notPlacedYet = true
	deviceNode.global_position = get_global_mouse_position() / camera.zoom + offset
	deviceNode.draged = true
	deviceNode.clicked = true
	deviceNode.mouseHover = true
	deviceNode.top_level = true
	get_tree().root.get_node("world/Devices").add_child(deviceNode)
	deviceNode.set_owner(get_tree().root.get_node("world"))
