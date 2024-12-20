class_name Device
extends Area2D

@export var mouseHover: bool = false
@export var clicked: bool = false
@export var draged: bool = false
@export var notPlacedYet: bool = false

@export var ignoreGlobalHighlight = false

@export var lastSafePosition: Vector2
@export var devicesCollided: Array[Device] = []
@export var subsystemsCollided: Array[Subsystem] = []

@export var collisionRectangle: Rect2
@export var subsystem: Subsystem

@export var canID: int = 0
@export var canEnabled: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Devices", true)
	lastSafePosition = global_position
	collisionRectangle = get_node("CollisionShape2D").shape.get_rect()
	subsystem = get_tree().root.get_node("world/Subsystems/worldSystem")
	subsystem.devices.append(self)
	area_entered.connect(_area_entered)
	area_exited.connect(_area_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#print(subsystemsCollided)
	#print(devicesCollided)
	pass


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.as_text_keycode() == "Delete" and clicked == true:
			for device in get_node("inputs").get_children():
				if device.connectingWire != null:
					device.connectingWire.queue_free()
			for device in get_node("outputs").get_children():
				if device.connectingWire != null:
					device.connectingWire.queue_free()
			queue_free()


func _input(event: InputEvent) -> void:
	var camera: worldCamera = get_tree().root.get_node("world/worldCamera")
	var offset = camera.global_position
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed == false:
				if clicked:
					endDrag()
				if mouseHover == false:
					print(mouseHover)
					clicked = false
					dehighlight()
					#get_tree().root.get_node("world/CanvasLayer/device GUI").deSelect()
				notPlacedYet = false
		elif event.button_index == 2:
			if notPlacedYet == true:
				queue_free()
			if draged == false:
				clicked = false
				dehighlight()
				get_tree().root.get_node("world/CanvasLayer/device GUI").deSelect()
	if draged:
		if event is InputEventMouseMotion:
			if event.button_mask == 1 and draged == true:
				moveToPoint(event.global_position / camera.zoom + offset, true)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed == true and mouseHover == true and Global.deviceHighlight:
				clicked = true
				get_tree().root.get_node("world/CanvasLayer/device GUI").selectDevice(self)
				startDrag()


func startDrag() -> void:
	draged = true
	#Ensure that the devices is viewed on top of any device that it is draged over
	top_level = true
	#Ensure that device stays hilighted while other devices to do not highlight
	Global.deviceHighlight = false
	ignoreGlobalHighlight = true


func endDrag() -> void:
	draged = false
	if devicesCollided.size() > 0 or subsystemCollision():
		if notPlacedYet:
			queue_free()
		moveToPoint(lastSafePosition, true)
	else:
		lastSafePosition = global_position
		if subsystemsCollided.size() > 0 and subsystemCollision() == false:
			if subsystemsCollided[0] != subsystem:
				addToSubsystem(subsystemsCollided[0])
		if get_tree().root.get_node("world/Subsystems/worldSystem") != subsystem:
			addToSubsystem(get_tree().root.get_node("world/Subsystems/worldSystem"))
	top_level = false
	Global.deviceHighlight = true
	print("Device set true")
	ignoreGlobalHighlight = false
	get_node("highlight").modulate = Color.WHITE


func addToSubsystem(_newSubsystem: Subsystem):
	subsystem.devices.pop_at(subsystem.devices.find(self))
	if subsystemsCollided.size() > 0:
		subsystem = subsystemsCollided[0]
	else: 
		subsystem = get_tree().root.get_node("world/Subsystems/worldSystem")
	subsystem.devices.append(self)


func moveToPoint(target: Vector2, snap: bool) -> void:
	if snap:
		global_position = snapped(target, Vector2(50,50))
		
	else:
		global_position = target
	
	moveWires(false)
	
	if devicesCollided.size() > 0:
		get_node("highlight").modulate = Color.RED
	else:
		get_node("highlight").modulate = Color.WHITE
	if subsystemCollision():
		get_node("highlight").modulate = Color.RED


func subsystemCollision() -> bool:
	for subsystemm in subsystemsCollided:
		if !subsystemm.collisionRectangle.encloses(getGlobalRect()):
			return true
	return false


func getGlobalRect() -> Rect2:
	var temp = collisionRectangle
	temp.position = to_global(temp.position)
	return temp


func moveWires(useSmart: bool) -> void:
	for node in get_node("inputs").get_children():
		node.updatePosition(useSmart)
	for node in get_node("outputs").get_children():
		node.updatePosition(useSmart)


func highlight() -> void:
	print([Global.deviceHighlight , ignoreGlobalHighlight])
	if Global.deviceHighlight or ignoreGlobalHighlight:
		get_node("highlight").visible = true
		for node in get_node("outputs").get_children():
			if node.connectingWire == null:
				node.highlight()
		


func dehighlight() -> void:
	get_node("highlight").visible = false
	for node in get_node("outputs").get_children():
		if node.hovered == false:
			node.dehighlight()


func anyHovered() -> bool:
	if mouseHover:
		return true
	for device in get_node("inputs").get_children():
		if device.hovered:
			return true
	for device in get_node("outputs").get_children():
		if device.hovered:
			return true
	return false
	
#func _draw() -> void:
	#draw_rect(collisionRectangle, Color.WEB_GREEN)


func _mouse_enter() -> void:

	mouseHover = true
	if !get_tree().root.get_node("world/CanvasLayer/Control/DeviceSelectContainer").mouseHovered:
		highlight()


func _mouse_exit() -> void:
	#print("exited") # Replace with function body.
	#print([clicked, draged])
	mouseHover = false
	if clicked == false and draged == false:
		dehighlight()


func getMeshTexture() -> Texture2D:
	var texture: MeshTexture = MeshTexture.new()
	var mesh: MeshInstance2D = get_node("mesh")
	texture.mesh = mesh.mesh
	return texture


func _area_entered(area: Area2D) -> void:
	if area is Device:
		devicesCollided.append(area)
	if area is Subsystem:
		subsystemsCollided.append(area)


func _area_exited(area: Area2D) -> void:
	if area is Device and devicesCollided.has(area):
		devicesCollided.pop_at(devicesCollided.find(area))
	if area is Subsystem and subsystemsCollided.has(area):
		subsystemsCollided.pop_at(subsystemsCollided.find(area))
