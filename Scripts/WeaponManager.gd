extends Node2D

@onready var player = get_parent()
var orbit_radius: float = 25.0
var orbit_speed: float = deg_to_rad(90)
var weapons: Array = []
var orbit_angle: float = 0.0

# --- Process the weapon's behavior ---
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
		var position_offset = Vector2(orbit_radius * cos(angle), orbit_radius * sin(angle))
		weapon.global_position = player.global_position + position_offset
		weapon.aim_at_mouse()

# --- Add a new weapon ---
func add_weapon(weapon: Node2D):
	weapons.append(weapon)
	add_child(weapon)
