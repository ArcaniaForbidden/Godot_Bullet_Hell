extends Node2D

@onready var player = get_parent()  # Player (parent) reference

var orbit_speed: float = deg_to_rad(90)  # Orbit speed in radians per second
var orbit_angle: float = 0.0  # Current orbit angle
var weapons: Array = []  # Array to store weapons

# --- Process the weapon's behavior ---
func _process(delta):
	if weapons.size() == 0:
		return
	var total_weapons = weapons.size()
	var angle_offset = 2 * PI / total_weapons  # Space weapons evenly in the orbit
	orbit_angle += orbit_speed * delta
	if orbit_angle >= 360.0:
		orbit_angle -= 360.0
	for i in range(total_weapons):
		var weapon = weapons[i]
		var angle = orbit_angle + angle_offset * i  # Calculate weapon angle
		var position_offset = Vector2(weapon.orbit_radius * cos(angle), weapon.orbit_radius * sin(angle))
		weapon.target_orbit_position = player.global_position + position_offset

# --- Add a new weapon ---
func add_weapon(weapon: Node2D):
	weapons.append(weapon)
	add_child(weapon)
