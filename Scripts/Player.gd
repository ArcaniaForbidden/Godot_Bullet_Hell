extends CharacterBody2D

@onready var animated_sprite2d = $AnimatedSprite2D
@onready var weapon_manager = $WeaponManager

var max_health: int = 30
var health: int
var speed = 150.0
var dash_speed = 300.0
var dash_duration = 0.33
var dash_cooldown = 1.0
var dash_timer = 0.0
var dash_cooldown_timer = 0.0
var is_running = false
var is_dashing = false
var input_direction = Vector2.ZERO
var last_direction = Vector2.RIGHT
var invincible: bool = false
var invincibility_duration: float = 5.0
var invincibility_timer: float = 0.0

func _ready():
	add_to_group("player")
	health = max_health
	animated_sprite2d.play("idle")
	var iron_spear1 = preload("res://Scenes/Weapons/IronSpear.tscn").instantiate()
	var iron_spear2 = preload("res://Scenes/Weapons/IronSpear.tscn").instantiate()
	var iron_spear3 = preload("res://Scenes/Weapons/IronSpear.tscn").instantiate()
	weapon_manager.add_weapon(iron_spear1)
	weapon_manager.add_weapon(iron_spear2)
	weapon_manager.add_weapon(iron_spear3)

func _process(delta):
	if invincible:
		invincibility_timer -= delta
		if invincibility_timer <= 0:
			invincible = false
			animated_sprite2d.modulate = Color(1,1,1,1)
		else:
			var flash_speed = 10.0
			animated_sprite2d.modulate = Color(1,1,1,1) if int(invincibility_timer * flash_speed) % 2 == 0 else Color(1,1,1,0.5)
	else:
		animated_sprite2d.modulate = Color(1,1,1,1)
	var input: Vector2 = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down")).normalized()
	if input.length() > 0:
		last_direction = input
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta
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
	if Input.is_action_just_pressed("ui_select") and dash_cooldown_timer <= 0 and not is_dashing:
		is_dashing = true
		dash_timer = dash_duration
		dash_cooldown_timer = dash_cooldown

func player_takes_damage(damage: int):
	if invincible:
		return
	health -= damage
	invincible = true
	invincibility_timer = invincibility_duration
	print("Player takes damage:", damage)
	print("Player remaining health:", health)
	if health <= 0:
		player_die()
	#else:
		#if SoundManager:
			#SoundManager.play("player_hurt", 0.0, global_position)

func player_die():
	print("Player has died")
	queue_free()
