class_name WireInput
extends Area2D

# Called when the node enters the scene tree for the first time.
var parent: Area2D
var hovered: bool = false
var clicked: bool = true
var connectingWire: Wire
@export var wireSizeMin: int = 15
@export var wireSizeMax: int = 15
@export var type = "power"
@export var color: Color

func _ready() -> void:
	parent = get_parent().get_parent()
	add_to_group("Inputs", true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func updatePosition(useSmart: bool) -> void:
	if connectingWire != null:
		if Input.is_key_label_pressed(KEY_SHIFT) or useSmart:
			connectingWire.smartUpdateEnd(global_position, "out")
		else:
			connectingWire.endPosition = global_position


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1:
		if event.is_pressed() and hovered == true:
			#print("pressed")
			pass


func highlight() -> void:
	if Global.inputHighlight:
		get_node("highlight").visible = true


func inRange(value, minVal, maxVal):
	if value >= minVal and value <= maxVal:
		return true
	return false


func highlightSpecific(wireType: String, wireColor: Color, wireSize: int):
	if Global.inputHighlight and wireType == type and wireColor == color and inRange(wireSize, wireSizeMin, wireSizeMax):
		get_node("highlight").visible = true


func dehighlight() -> void:
	get_node("highlight").visible = false


func _mouse_enter() -> void:
	#print("input enter")
	if parent.draged == false:
		parent.input_pickable = false
		hovered = true


func _mouse_exit() -> void:
	#print("input exit")
	parent.input_pickable = true
	hovered = false
