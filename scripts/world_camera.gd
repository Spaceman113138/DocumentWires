class_name worldCamera
extends Camera2D


var initialPosition: Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialPosition = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (event.button_index == 4 and event.is_pressed()):
			zoom = Vector2(min(zoom.x + .1, 1), min(zoom.x + .1, 1))
		elif event.button_index == 5 and event.is_pressed():
			zoom = Vector2(max(zoom.x - .1, .25), max(zoom.x - .1, .25))
	
	if event is InputEventMouseMotion:
		if (event.button_mask >= 4 and event.button_mask < 15)  or (event.button_mask == 2):
			global_position += -event.relative / zoom


func _draw() -> void:
	if Input.is_key_pressed(KEY_CTRL):
		var mousePos: Vector2 = get_global_mouse_position() - position#/ zoom
		var xMin: Vector2 = Vector2(mousePos.x - get_viewport().size.x/zoom.x, mousePos.y)
		var xMax: Vector2 = Vector2(mousePos.x + get_viewport().size.x/zoom.x, mousePos.y)
		var yMin: Vector2 = Vector2(mousePos.x, mousePos.y - get_viewport().size.y/zoom.y)
		var yMax: Vector2 = Vector2(mousePos.x, mousePos.y + get_viewport().size.y/zoom.y)
		draw_dashed_line(xMin , xMax, Color.WHITE, -.1, 10/zoom.x)
		draw_dashed_line(yMin , yMax, Color.WHITE, -.1, 10/zoom.y)
