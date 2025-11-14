extends Camera2D

@onready var player = get_node_or_null("/root/Game/PlayerNode2D")


# Camera settings
var custom_offset = Vector2(0, 0)  # Optional, to adjust the camera's offset
var zoom_speed = 0.1
var min_zoom = Vector2(3, 3)  # Zoom in (closer)
var max_zoom = Vector2(5, 5)      # Zoom out (further)

func _ready():
	print(player)
	zoom = min_zoom
	global_position = player.position + custom_offset

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_camera(-zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_camera(zoom_speed)	

func _process(_delta):
	if player:
		global_position = player.position + custom_offset

func zoom_camera(delta):
	zoom += Vector2(delta, delta)
	zoom = zoom.clamp(min_zoom, max_zoom)
