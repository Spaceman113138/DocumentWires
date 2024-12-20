extends Node2D
class_name deviceCreator


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().root.size_changed.connect(resize)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func resize():
	print(get_window().size)
	#var node: Node2D = get_node("devicePlaceholder")
	#node.global_position = get_node("Camera2D").global_position
	#print(node.global_position)
