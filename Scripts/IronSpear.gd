extends Node2D

@onready var weapon_manager = get_parent()  # Get the parent (WeaponManager)

var rotation_offset = deg_to_rad(45)

# --- Process the weapon's behavior ---
func _process(delta):
	aim_at_mouse()

# --- Aiming at the mouse ---
func aim_at_mouse():
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - global_position).normalized()
	rotation = direction.angle() + rotation_offset
