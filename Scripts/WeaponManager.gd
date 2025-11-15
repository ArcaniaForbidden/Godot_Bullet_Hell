extends Node2D

@onready var player = get_parent()

var orbit_speed: float = deg_to_rad(90)
var orbit_angle: float = 0.0
var weapons: Array = []

func _process(delta):
	if weapons.size() == 0:
		return
	var total_weapons = weapons.size()
	var angle_offset = 2 * PI / total_weapons
	orbit_angle += orbit_speed * delta
	if orbit_angle >= 360.0:
		orbit_angle -= 360.0
	for i in range(total_weapons):
		var weapon = weapons[i]
		var angle = orbit_angle + angle_offset * i
		var position_offset = Vector2(weapon.orbit_radius * cos(angle), weapon.orbit_radius * sin(angle))
		weapon.target_orbit_position = player.global_position + position_offset

func add_weapon(weapon: Node2D):
	weapons.append(weapon)
	add_child(weapon)
