extends Area2D
class_name InputPlaceholder


@export var wireSizeMin: int = 15
@export var wireSizeMax: int = 15:
	set(val):
		wireSizeMax = val
		get_node("CollisionShape2D").shape.radius = wireSizeMax
		get_node("highlight").scale = Vector2(wireSizeMax * 2 + 5, wireSizeMax * 2 + 5)
		get_node("body").scale = Vector2(wireSizeMax * 2, wireSizeMax * 2)
@export var type = "power"
@export var color: Color:
	set(val):
		color = val
		get_node("body").modulate = val


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("CollisionShape2D").shape.radius = wireSizeMax
	get_node("highlight").scale = Vector2(wireSizeMax * 2 + 5, wireSizeMax * 2 + 5)
	get_node("body").scale = Vector2(wireSizeMax * 2, wireSizeMax * 2)
	color = get_node("body").modulate 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func getInputNode() -> WireInput:
	var input: WireInput = WireInput.new()
	input.add_child(get_node("CollisionShape2D").duplicate())
	input.add_child(get_node("highlight").duplicate())
	input.add_child(get_node("body").duplicate())
	input.wireSizeMax = wireSizeMax
	input.wireSizeMin = wireSizeMin
	input.type = type
	input.color = color
	input.position = position
	input.name = name
	return input
	


static func getPlaceholderNode(node: WireInput) -> InputPlaceholder:
	var input = InputPlaceholder.new()
	input.add_child(node.get_node("CollisionShape2D").duplicate())
	input.add_child(node.get_node("highlight").duplicate())
	input.add_child(node.get_node("body").duplicate())
	input.color = node.color
	input.type = node.type
	input.wireSizeMax = node.wireSizeMax
	input.wireSizeMin = node.wireSizeMin
	input.name = node.name
	input.position = node.position
	return input
