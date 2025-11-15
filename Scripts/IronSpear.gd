extends Node2D

@onready var weapon_manager = get_parent()

var orbit_radius = 25
var rotation_offset = deg_to_rad(45)
var attack_range: float = 100.0
var attack_duration: float = 0.33
var attack_cooldown: float = 1.5
var is_attacking: bool = false
var has_cooldown: bool = false
var cooldown_timer: float = 0.0
var original_position: Vector2
var target_orbit_position: Vector2
var return_speed := 5.0

func _ready() -> void:
	has_cooldown = true

# --- Process the weapon's behavior ---
func _process(delta):
	if is_attacking:
		return  
	if has_cooldown:
		cooldown_timer -= delta
		if cooldown_timer <= 0.5 * attack_cooldown:
			aim_at_mouse()
		if cooldown_timer <= 0:
			has_cooldown = false
			cooldown_timer = 0
	global_position = global_position.lerp(target_orbit_position, delta * return_speed)
	if !is_attacking and !has_cooldown:
		perform_attack()

# --- Aiming at the mouse ---
func aim_at_mouse():
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - global_position).normalized()
	rotation = direction.angle() + rotation_offset

# --- Perform the attack (lunge) ---
func perform_attack():
	if has_cooldown:
		return
	is_attacking = true
	has_cooldown = true
	cooldown_timer = attack_cooldown
	original_position = global_position
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - global_position).normalized()
	var target_position = global_position + direction * attack_range
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_position, attack_duration)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.finished.connect(Callable(self, "_on_attack_finished"))

# --- Reset the weapon after the attack ---
func _on_attack_finished():
	is_attacking = false
