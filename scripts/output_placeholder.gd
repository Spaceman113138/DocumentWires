extends Area2D
class_name OutputPlaceholder


@export var color: Color = Color.RED:
	set(val):
		color = val
		print(get_children())
		get_node("base").modulate = val
@export var wireSize: int = 15: 
	set(val):
		wireSize = val
		get_node("CollisionShape2D").shape.radius = wireSize
		get_node("highlight").scale = Vector2(wireSize * 2 + 5, wireSize * 2 + 5)
		get_node("base").scale = Vector2(wireSize * 2, wireSize * 2)
@export var wireMin: int = 10
@export var wireMax: int = 20
@export var type: String = "power"

func _ready() -> void:
	get_node("CollisionShape2D").shape.radius = wireSize
	get_node("highlight").scale = Vector2(wireSize * 2 + 5, wireSize * 2 + 5)
	get_node("base").scale = Vector2(wireSize * 2, wireSize * 2)
	color = get_node("base").modulate 


func getOutputNode() -> WireOutput:
	var output: WireOutput = WireOutput.new()
	output.add_child(get_node("CollisionShape2D").duplicate())
	output.add_child(get_node("highlight").duplicate())
	output.add_child(get_node("base").duplicate())
	output.name = name
	output.color = color
	output.wireSize = wireSize
	output.type = type
	output.position = position
	for node in output.get_children():
		#print(node)
		node.set_owner(output)
		#print(node)
	
	return output


static func getPlaceholderNode(node: WireOutput) -> OutputPlaceholder:
	var output = OutputPlaceholder.new()
	output.add_child(node.get_node("CollisionShape2D").duplicate())
	output.add_child(node.get_node("highlight").duplicate())
	output.add_child(node.get_node("base").duplicate())
	output.color = node.color
	output.name = node.name
	output.wireSize = node.wireSize
	output.type = node.type
	output.position = node.position
	return output
