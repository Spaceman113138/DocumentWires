extends TabContainer
class_name DeviceSelectContainer


var mouseHovered: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DirAccess.make_dir_absolute("user://devices")
	loadTabs()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if mouseHovered and event is InputEventMouseButton and event.button_index == 1:
		get_viewport().set_input_as_handled()


func loadTabs() -> void:
	var devicesDir: DirAccess = DirAccess.open("res://devices/")
	for folderName in devicesDir.get_directories():
		var folder: DirAccess = DirAccess.open("res://devices/" + folderName)
		var Scontainter: ScrollContainer = ScrollContainer.new()
		Scontainter.name = folderName
		var Hcontainter: HBoxContainer = HBoxContainer.new()
		Hcontainter.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		Hcontainter.size_flags_vertical = Control.SIZE_EXPAND_FILL
		add_child(Scontainter)
		Scontainter.add_child(Hcontainter)
		var x: int = 1
		for categoryName in folder.get_directories():
			var categoryDir: DirAccess = DirAccess.open("res://devices/" + folderName + "/" + categoryName)
			#print(categoryDir.get_files())
			for deviceName: String in categoryDir.get_files():
				#print(categoryDir.get_current_dir() + "/" + deviceName)
				var device: PackedScene = load(categoryDir.get_current_dir() + "/" + deviceName)
				var button: DeviceButton = DeviceButton.new(deviceName.trim_suffix(".tscn"), device)
				Hcontainter.add_child(button)
			if x != folder.get_directories().size():
				Hcontainter.add_child(VSeparator.new())
			x += 1
	
	var folder: DirAccess = DirAccess.open("user://devices/")
	var Scontainer: ScrollContainer = ScrollContainer.new()
	Scontainer.name = "User Created"
	var Hcontainer: HBoxContainer = HBoxContainer.new()
	Hcontainer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	Hcontainer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(Scontainer)
	Scontainer.add_child(Hcontainer)
	for deviceName: String in folder.get_files():
		var device: PackedScene = load(folder.get_current_dir() + "/" + deviceName)
		var button: DeviceButton = DeviceButton.new(deviceName.trim_suffix(".tscn"), device)
		Hcontainer.add_child(button)

func _on_control_mouse_entered() -> void:
	mouseHovered = true


func _on_control_mouse_exited() -> void:
	mouseHovered = false
