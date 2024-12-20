extends Control
class_name menu_gui


@onready var packed: PackedScene = preload("res://scenes/device_creator.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("PanelContainer/HBoxContainer/name edit").text = Global.layoutName


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func saveAtDir(path: String):
	print(path)
	var packedLayout: PackedScene = PackedScene.new()
	packedLayout.pack(get_tree().root.get_node("world"))
	ResourceSaver.save(packedLayout, path)
	Global.hasBeenSaved = true
	Global.layoutDir = path


func _on_save_dialogue_dir_selected(dir: String) -> void:
	saveAtDir(dir + "/" + Global.layoutName + ".tscn")


func _on_save_as_button_pressed() -> void:
	get_node("SaveDialogue").visible = true


func _on_save_button_pressed() -> void:
	if Global.layoutDir != null:
		saveAtDir(Global.layoutDir)
	else:
		get_node("SaveDialogue").visible = true


func _on_load_button_pressed() -> void:
	get_node("LoadDialogue").visible = true


func _on_load_dialogue_file_selected(path: String) -> void:
	var packedLayout = load(path)
	get_tree().change_scene_to_packed(packedLayout)


func _on_name_edit_text_changed(new_text: String) -> void:
	Global.layoutName = new_text


func _on_new_device_button_pressed() -> void:
	var node = packed.instantiate()
	get_tree().root.add_child(node)
	get_tree().root.remove_child(get_tree().root.get_node("world"))
	
