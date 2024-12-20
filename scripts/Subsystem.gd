extends Area2D
class_name Subsystem

@export var collisionRectangle: Rect2
@export var devices: Array[Device] = []
@export var boxSize: Vector2 = Vector2(100,100)

@export var mouseHover: bool = false
@export var clicked: bool = false
@export var offsetToCenter: Vector2

@export var reSize: bool = false
@export var sizeDirection = Vector2.ZERO

@export var lastSafePosition: Vector2
@export var devicesCollided: Array[Device] = []
@export var subsystemsCollided: Array[Subsystem] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lastSafePosition = global_position
	setSize(boxSize)
	#collisionRectangle.position = to_global(collisionRectangle.position)
	
	queue_redraw()


func setSize(size: Vector2):
	boxSize = size
	var collision: CollisionShape2D = get_node("CollisionShape2D")
	collision.scale = size + Vector2(20,20)
	var outline: MeshInstance2D = get_node("outlineMesh")
	outline.scale = size + Vector2(15,15)
	get_node("innerMesh").scale = size
	collisionRectangle = collision.shape.get_rect() 
	collisionRectangle.size = collisionRectangle.size * collision.scale
	collisionRectangle.position -= collisionRectangle.size/2
	collisionRectangle = Rect2(collisionRectangle.position + global_position, collisionRectangle.size)
	
	if collison():
		get_node("outlineMesh").modulate = Color.RED
	else:
		get_node("outlineMesh").modulate = Color8(0,0,132)
		lastSafePosition = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	var camera: worldCamera = get_tree().root.get_node("world/worldCamera")
	var offset = camera.global_position
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.is_pressed() == false:
				clicked = false
				reSize = false
				if collison():
					moveToPoint(lastSafePosition, true)
				get_node("outlineMesh").modulate = Color8(0,0,132)
	if event is InputEventMouseMotion:
		if onEdge(event.global_position / camera.zoom + offset):
			get_node("outlineMesh").modulate = Color.WHITE
		else:
			get_node("outlineMesh").modulate = Color8(0,0,132)
		if event.button_mask == 1 and reSize == true:
			print(sizeDirection)
			if sizeDirection == Vector2.RIGHT:
				var xSize: float = abs((event.global_position.x / camera.zoom.x + offset.x) - global_position.x) * 2
				setSize(Vector2(xSize, boxSize.y))
			else:
				var ySize: float = abs((event.global_position.y / camera.zoom.y + offset.y) - global_position.y) * 2
				setSize(Vector2(boxSize.x, ySize))
		if event.button_mask == 1 and clicked == true and mouseHover == true:
			moveToPoint(event.global_position  / camera.zoom + offset - offsetToCenter, true)


func _unhandled_input(event: InputEvent) -> void:
	var camera: worldCamera = get_tree().root.get_node("world/worldCamera")
	var offset = camera.global_position
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.is_pressed() and onEdge(event.global_position / camera.zoom):
				reSize = true
				if onXEdge(event.global_position / camera.zoom + offset):
					sizeDirection = Vector2.RIGHT
				else:
					sizeDirection = Vector2.UP
			#print([event.is_pressed() , mouseHover == true , reSize == false])
			elif event.is_pressed() and mouseHover == true and reSize == false:
				clicked = true
				offsetToCenter = event.global_position / camera.zoom + offset - global_position
				for device in devices:
					if device.anyHovered() == true:
						clicked = false


func onEdge(eventPos: Vector2) -> bool:
	if onYEdge(eventPos):
		return true
	if onXEdge(eventPos):
		return true
	return false


func onYEdge(eventPos: Vector2) -> bool:
	var onY: bool = false
	if abs(eventPos.y - global_position.y) < (boxSize.y - 20)/2 or abs(eventPos.y - global_position.y) > (boxSize.y + 20)/2:
		onY = false
	else:
		onY = true
	if onY:
		if abs(eventPos.x - global_position.x) < (boxSize.x + 20)/2:
			return true
	return false


func onXEdge(eventPos: Vector2) -> bool:
	var onX: bool = true
	if abs(eventPos.x - global_position.x) < (boxSize.x - 20)/2 or abs(eventPos.x - global_position.x) > ( boxSize.x + 20)/2:
		onX = false
	else:
		onX = true
	if onX:
		if abs(eventPos.y - global_position.y) < (boxSize.y+ 20)/2:
			return true
	return false

func _draw() -> void:
	pass
	#draw_rect(Rect2(to_local(collisionRectangle.position), collisionRectangle.size), Color.YELLOW)


func moveToPoint(target: Vector2, snap: bool):
	var delta: Vector2 = target - global_position
	if snap:
		delta = target - global_position
		global_position = snapped(target, Vector2(50,50))
	else:
		delta = target - global_position
		global_position = target
	
	if collison():
		get_node("outlineMesh").modulate = Color.RED
	else:
		get_node("outlineMesh").modulate = Color8(0,0,132)
		lastSafePosition = global_position
	
	updateRectangle()
	for device in devices:
		device.moveToPoint(device.global_position + delta, snap)


func collison() -> bool:
	if subsystemsCollided.size() > 0:
		return true
	if devicesCollided.size() > 0:
		for device in devicesCollided:
			if !devices.has(device):
				if !collisionRectangle.encloses(device.getGlobalRect()):
					return true
	return false


func updateRectangle():
	var collision: CollisionShape2D = get_node("CollisionShape2D")
	collisionRectangle = collision.shape.get_rect() 
	collisionRectangle.size = collisionRectangle.size * collision.scale
	collisionRectangle.position -= collisionRectangle.size/2
	collisionRectangle = Rect2(collisionRectangle.position + global_position, collisionRectangle.size)
	queue_redraw()


func _mouse_enter() -> void:
	mouseHover = true


func _mouse_exit() -> void:
	mouseHover = false


func _on_area_entered(area: Area2D) -> void:
	if area is Device:
		devicesCollided.append(area)
	if area is Subsystem:
		subsystemsCollided.append(area)


func _on_area_exited(area: Area2D) -> void:
	if area is Device and devicesCollided.has(area):
		devicesCollided.pop_at(devicesCollided.find(area))
	if area is Subsystem and subsystemsCollided.has(area):
		subsystemsCollided.pop_at(subsystemsCollided.find(area))
