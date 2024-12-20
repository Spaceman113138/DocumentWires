class_name WireOutput
extends Area2D

var parent: Area2D
var hovered: bool = false
var clicked: bool = true
var connectingWire: Wire
@export var color: Color = Color.RED
@export var wireSize: int = 15
@export var wireMin: int = 10
@export var wireMax: int = 20
@export var type: String = "power"

const wireScene = preload("res://scenes/wire.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent().get_parent()
	add_to_group("Output", true)
	get_node("CollisionShape2D").shape.radius = wireSize


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func updatePosition(useSmart: bool) -> void:
	if connectingWire != null:
		if Input.is_key_label_pressed(KEY_SHIFT) or useSmart:
			connectingWire.smartUpdateEnd(global_position, "init")
		else:
			connectingWire.initialPosition = global_position


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1:
		if !event.is_pressed() and hovered == true and connectingWire == null:
			var instance = wireScene.instantiate()
			instance.wireColor = color
			instance.global_position = global_position
			instance.initialPosition = global_position
			instance.endPosition = global_position
			instance.wiresize = wireSize * 2
			instance.type = type
			instance.z_index = z_index
			connectingWire = instance
			get_tree().root.get_node("world/Wires").add_child(instance)
			instance.set_owner(get_tree().root.get_node("world"))


func highlight() -> void:
	if Global.outputHighlight:
		get_node("highlight").visible = true


func dehighlight() -> void:
	get_node("highlight").visible = false


func _mouse_enter() -> void:
	#print("input enter")
	if parent.draged == false:
		parent.input_pickable = false
		hovered = true
	if connectingWire == null:
		highlight()

func _mouse_exit() -> void:
	#print("input exit")
	parent.input_pickable = true
	hovered = false
	dehighlight()
