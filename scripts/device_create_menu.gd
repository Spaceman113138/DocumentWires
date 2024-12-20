extends Control

var hasBeenSaved: bool = false
var devicePacked: PackedScene = preload("res://scenes/device_placeholder.tscn")
const outputGUI:PackedScene = preload("res://scenes/output_gui.tscn")
const inputGUI: PackedScene = preload("res://scenes/input_gui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DirAccess.make_dir_absolute("user://devices")
	get_node("HBoxContainer/name Edit").text = get_tree().root.get_node("deviceCreator").get_child(0).name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_save_pressed() -> void:
	var device = get_tree().root.get_node("deviceCreator").get_child(0)
	var realDevice = Device.new()
	realDevice.name = device.name
	var collisionShape = device.get_node("CollisionShape2D")
	var bodyMesh = device.get_node("base")
	bodyMesh.name = "base"
	var highlightMesh = device.get_node("highlight")
	highlightMesh.name = "highlight"
	realDevice.add_child(collisionShape.duplicate())
	realDevice.add_child(highlightMesh.duplicate())
	realDevice.add_child(bodyMesh.duplicate())
	var outputsNode = Node2D.new()
	outputsNode.name = "outputs"
	var inputsNode = Node2D.new()
	inputsNode.name = "inputs"
	realDevice.add_child(outputsNode)
	realDevice.add_child(inputsNode)
	
	for input: InputPlaceholder in device.get_node("inputs").get_children():
		var node: WireInput = input.getInputNode()
		realDevice.get_node("inputs").add_child(node)
		node.set_owner(realDevice)
		for nodes in node.get_children():
			nodes.set_owner(realDevice)
	for output: OutputPlaceholder in device.get_node("outputs").get_children():
		var node: WireOutput = output.getOutputNode()
		realDevice.get_node("outputs").add_child(node)
		node.set_owner(realDevice)
		for nodes in node.get_children():
			nodes.set_owner(realDevice)
			
	
	for node in realDevice.get_children(true):
		node.set_owner(realDevice)
	
	var count:int = 1
	var initName = realDevice.name
	while FileAccess.file_exists("user://devices//" + realDevice.name + ".tscn") and !hasBeenSaved:
		realDevice.name = initName + str(count)
		count += 1
		get_node("HBoxContainer/name Edit").text = realDevice.name
	
	var packed: PackedScene = PackedScene.new()
	packed.pack(realDevice)
	
	ResourceSaver.save(packed, "user://devices/" + realDevice.name + ".tscn")
	hasBeenSaved = true
	print("saved")


func _on_name_edit_text_changed(new_text: String) -> void:
	get_tree().root.get_node("deviceCreator").get_child(0).name = new_text


func _on_load_pressed() -> void:
	get_node("FileDialog").visible = true


func _on_file_dialog_file_selected(path: String) -> void:
	get_parent().get_child(1).clear()
	get_tree().root.get_node("deviceCreator").get_child(0).queue_free()
	var packed: PackedScene = load(path)
	var device: Device = packed.instantiate()
	
	var tempDevice:devicePlaceholder = devicePacked.instantiate()
	tempDevice.get_node("base").mesh = device.get_node("base").mesh
	tempDevice.get_node("highlight").mesh = device.get_node("highlight").mesh 
	tempDevice.get_node("CollisionShape2D").shape = device.get_node("CollisionShape2D")
	var otherGUI = get_parent().get_child(1)
	for output in device.get_node("outputs").get_children():
		var temp = OutputPlaceholder.getPlaceholderNode(output)
		tempDevice.get_node("outputs").add_child(temp)
		var gui: OutputGUI = outputGUI.instantiate()
		gui.setOutput(temp)
		otherGUI.get_node("ScrollContainer/VBoxContainer/HSeparator").add_sibling(gui)
		temp.set_owner(temp.get_parent())
		otherGUI.toClear.append(gui)
	for input in device.get_node("inputs").get_children():
		var temp = InputPlaceholder.getPlaceholderNode(input)
		tempDevice.get_node("inputs").add_child(temp)
		var gui: InputGUI = inputGUI.instantiate()
		gui.setInput(temp)
		otherGUI.get_node("ScrollContainer/VBoxContainer/HSeparator2").add_sibling(gui)
		temp.set_owner(temp.get_parent())
		otherGUI.toClear.append(gui)
	
	tempDevice.global_position = get_tree().root.get_node("deviceCreator/Camera2D").global_position
	get_tree().root.get_node("deviceCreator").add_child(tempDevice)
	get_tree().root.get_node("deviceCreator").move_child(tempDevice,0)
	get_parent().get_child(1).reload()
	hasBeenSaved = true


func _on_return_pressed() -> void:
	get_tree().root.add_child(Global.layoutNode)
	get_tree().root.get_node("deviceCreator").queue_free()


func _on_new_device_pressed() -> void:
	get_parent().get_child(1).clear()
	get_tree().root.get_node("deviceCreator").get_child(0).queue_free()
	var node = devicePacked.instantiate()
	get_tree().root.get_node("deviceCreator").add_child(node)
	get_tree().root.get_node("deviceCreator").move_child(node, 0)
	#get_tree().root.print_tree_pretty()
	node.global_position = get_tree().root.get_node("deviceCreator/Camera2D").global_position
	hasBeenSaved = false
	get_parent().get_child(1).reload()
	get_node("HBoxContainer/name Edit").text = node.name
