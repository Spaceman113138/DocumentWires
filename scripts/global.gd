class_name global
extends Node

var deviceHighlight: bool = true
var inputHighlight: bool = true
var outputHighlight: bool = true

var layoutName: String = "default Name"
var hasBeenSaved: bool = false

var layoutDir: String

@onready var layoutNode = get_tree().root.get_node("world")
