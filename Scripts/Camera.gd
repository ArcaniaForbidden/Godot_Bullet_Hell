extends Camera2D

@onready var player = get_node_or_null("/root/GameScene/PlayerNode2D")

var zoom_speed = 0.25
var min_zoom = Vector2(3, 3)
var max_zoom = Vector2(6, 6)
var player_alive := true

func _ready():
	zoom = min_zoom
	if player:
		global_position = player.position

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_camera(-zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_camera(zoom_speed)	

func _process(_delta):
	if player_alive and player:
		global_position = player.position

func zoom_camera(delta):
	zoom += Vector2(delta, delta)
	zoom = zoom.clamp(min_zoom, max_zoom)
