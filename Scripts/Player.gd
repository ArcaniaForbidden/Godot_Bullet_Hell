extends CharacterBody2D

@onready var animated_sprite2d = $AnimatedSprite2D
@onready var weapon_manager = $WeaponManager

var speed = 150.0
var dash_speed = 300.0
var dash_duration = 0.33
var dash_cooldown = 1.0
var dash_timer = 0.0
var cooldown_timer = 0.0
var is_running = false
var is_dashing = false
var input_direction = Vector2.ZERO
var last_direction = Vector2.RIGHT

func _ready():
	var iron_spear1 = preload("res://Scenes/IronSpear.tscn").instantiate()
	var iron_spear2 = preload("res://Scenes/IronSpear.tscn").instantiate()
	var iron_spear3 = preload("res://Scenes/IronSpear.tscn").instantiate()
	weapon_manager.add_weapon(iron_spear1)
	weapon_manager.add_weapon(iron_spear2)
	weapon_manager.add_weapon(iron_spear3)

func _process(delta):
	var input: Vector2 = Vector2(Input.get_axis("ui_left", "ui_right"),
								 Input.get_axis("ui_up", "ui_down")).normalized()
	if input.length() > 0:
		last_direction = input
	if cooldown_timer > 0:
		cooldown_timer -= delta
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
	if input.length() == 0 and is_dashing:
		velocity = last_direction * dash_speed
		move_and_slide()
	if input.length() > 0 or is_dashing:
		if is_dashing:
			velocity = input * dash_speed
		else:
			velocity = input * speed
		move_and_slide()
		if not is_running:
			animated_sprite2d.animation = "running"
			animated_sprite2d.play("running")
			is_running = true
	else:
		if is_running:
			animated_sprite2d.animation = "idle"
			animated_sprite2d.play("idle")
			is_running = false
	if input.x:
		animated_sprite2d.flip_h = true if input.x < 0 else false
	if Input.is_action_just_pressed("ui_select") and cooldown_timer <= 0 and not is_dashing:
		is_dashing = true
		dash_timer = dash_duration
		cooldown_timer = dash_cooldown
