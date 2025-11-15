extends Node2D

var damage = 10
var orbit_radius = 25
var rotation_offset = deg_to_rad(45)
var attack_range: float = 150.0
var attack_duration: float = 0.33
var attack_cooldown: float = 1.33
var is_attacking: bool = false
var has_cooldown: bool = false
var cooldown_timer: float = 0.0
var target_orbit_position: Vector2
var return_speed := 5.0
var hit_enemies := {}

func _ready() -> void:
	has_cooldown = true
	$Area2D.body_entered.connect(_on_body_entered)

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

func aim_at_mouse():
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - global_position).normalized()
	rotation = direction.angle() + rotation_offset

func perform_attack():
	if has_cooldown:
		return
	is_attacking = true
	has_cooldown = true
	cooldown_timer = attack_cooldown
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - global_position).normalized()
	var target_position = global_position + direction * attack_range
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_position, attack_duration)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.finished.connect(Callable(self, "_on_attack_finished"))

func _on_attack_finished():
	is_attacking = false
	hit_enemies.clear() 

func _on_body_entered(enemy):
	if !is_attacking:
		return
	if enemy in hit_enemies:
		return
	if enemy.has_method("take_damage"):
		hit_enemies[enemy] = true
		enemy.take_damage(damage)
