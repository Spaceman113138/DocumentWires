class_name Wire
extends Area2D


@export var wireColor: Color = Color.RED
@export var wiresize: int = 15
@export var type: String = "power"


@export var initialPosition: Vector2:
	set(val):
		initialPosition = val
		queue_redraw()
@export var interiorPoints: Array[Vector2] = []
@export var intermediaryPoint: Vector2 = Vector2.ZERO
@export var endPosition: Vector2:
	set(val):
		endPosition = val
		if closed == true:
			get_node("endCollider").global_position = val
		queue_redraw()

@export var closed: bool = false
@export var selected: bool = true
@export var hasIntermidiery: bool = false

var collidedInputs: Array[WireInput] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialPosition = position
	Global.deviceHighlight = false
	get_tree().call_group("Inputs", "highlightSpecific", type, wireColor, wiresize/2.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#print(endPosition)
	#print(collidedInputs)
	queue_redraw()
	pass


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.as_text_keycode() == "Escape" and event.is_pressed() == false and closed == false:
			Global.deviceHighlight = true
			get_tree().call_group("Inputs", "dehighlight")
			self.queue_free()

func _input(event: InputEvent) -> void:
	var camera: worldCamera = get_tree().root.get_node("world/worldCamera")
	var offset = camera.global_position
	if closed == false:
		if event is InputEventMouseMotion:
			get_node("endCollider").global_position = event.global_position / camera.zoom + offset
			moveEndpoint(event.global_position / camera.zoom + offset)
	
	if event is InputEventMouseButton:
		#print(event)
		if event.button_index == 2:
			if event.is_pressed() == false and closed == false:
				Global.deviceHighlight = true
				get_tree().call_group("Inputs", "dehighlight")
				self.queue_free()
		if event.button_index == 1:
			if event.pressed == false and selected == true and closed == false:
				if collidedInputs.size() > 0:
					closed = true
					selected = false
					if hasIntermidiery:
						interiorPoints.append(intermediaryPoint)
					hasIntermidiery = false
					closestInput().connectingWire = self
					moveEndpoint(event.global_position / camera.zoom + offset)
					Global.deviceHighlight = true
					get_tree().call_group("Inputs", "dehighlight")
					print(interiorPoints)
				else:
					if hasIntermidiery:
						interiorPoints.append(intermediaryPoint)
					interiorPoints.append(calcMousePoint(event.global_position / camera.zoom + offset))
				queue_redraw()

func _draw() -> void:
	var pointsArray = [initialPosition]
	pointsArray.append_array(interiorPoints)
	if hasIntermidiery:
		pointsArray.append(intermediaryPoint)
	pointsArray.append(endPosition)
	var localPointsArray = []
	for point in pointsArray:
		localPointsArray.append(to_local(point))


	var x = 0
	while x < localPointsArray.size():
		draw_circle(localPointsArray[x], wiresize/2.0, wireColor)
		if x != 0:
			draw_line(localPointsArray[x-1],localPointsArray[x], wireColor, wiresize, true)
		x += 1
	x = 0
	while x < localPointsArray.size():
		draw_circle(localPointsArray[x],5, wireColor)
		if x != 0:
			draw_line(localPointsArray[x-1],localPointsArray[x], wireColor, 10, true)
		x += 1


func moveEndpoint(mousePos: Vector2) -> void:
	endPosition = calcMousePoint(mousePos)
	#print("ran")
		#print("shift")
	var lastpoint = initialPosition
	if interiorPoints.size() > 0:
		lastpoint = interiorPoints[interiorPoints.size() - 1]
	
	if Input.is_key_pressed(KEY_ALT) and closed == false:
		intermediaryPoint = Vector2(endPosition.x,lastpoint.y)
		hasIntermidiery = true
	elif Input.is_key_pressed(KEY_SHIFT) and closed == false:
		intermediaryPoint = Vector2(lastpoint.x, endPosition.y)
		hasIntermidiery = true
	else:
		hasIntermidiery = false
	
	
func smartUpdateEnd(newPos: Vector2, wType: String) -> void:
	if interiorPoints.size() > 0:
		if wType == "out":
			var secLastPoint = interiorPoints[interiorPoints.size() - 1]
		
			if is_equal_approx(endPosition.x, secLastPoint.x):
				interiorPoints[interiorPoints.size() - 1].x = newPos.x
			elif is_equal_approx(endPosition.y, secLastPoint.y):
				interiorPoints[interiorPoints.size() - 1].y = newPos.y
		else:
			var secLastPoint = interiorPoints[0]
		
			if is_equal_approx(initialPosition.x, secLastPoint.x):
				interiorPoints[0].x = newPos.x
			elif is_equal_approx(initialPosition.y, initialPosition.y):
				interiorPoints[0].y = newPos.y
	
	if wType == "out":
		endPosition = newPos
	else:
		initialPosition = newPos
	

func calcMousePoint(mousePos: Vector2) -> Vector2:
	if collidedInputs.size() > 0:
		return closestInput().global_position
	else:
		return mousePos


#Assumes that there is a collided input
func closestInput() -> WireInput:
	var smallDistance = 100000000
	var smallest = collidedInputs[0]
	
	for wInput in collidedInputs:
		var distance = global_position.distance_squared_to(wInput.global_position)
		if distance < smallDistance:
			smallDistance = distance
			smallest = wInput
	return smallest


func inRange(value, minVal, maxVal):
	if value >= minVal and value <= maxVal:
		return true
	return false


func _on_end_collider_area_entered(area: Area2D) -> void:
	if area is WireInput and area.connectingWire == null and area.type == type and area.color == wireColor:
		collidedInputs.append(area)


func _on_end_collider_area_exited(area: Area2D) -> void:
	if area is WireInput and area in collidedInputs:
		collidedInputs.pop_at(collidedInputs.find(area))
