extends CharacterBody2D

@onready var animated_sprite2d = $AnimatedSprite2D
@onready var damage_area = $DamageArea

@export var max_health: int = 50
@export var damage: int = 10

var health: int
var playing_damage_sound := false
var flashing := false
var flash_duration := 0.2  # How long each flash lasts
var flash_timer := 0.0

func _ready():
	add_to_group("enemy")
	health = max_health
	animated_sprite2d.play("idle")

func _process(delta):
	if flashing:
		flash_timer -= delta
		if flash_timer <= 0:
			flashing = false
			animated_sprite2d.modulate = Color(1, 1, 1)
	for body in damage_area.get_overlapping_bodies():
		if body.is_in_group("player") and not body.invincible:
			body.player_takes_damage(damage)

func take_damage(damage_taken: int):
	play_damage_sound()
	damage_flash()
	health -= damage_taken
	if health <= 0:
		die()

func die():
	queue_free()

func damage_flash():
	flashing = true
	flash_timer = flash_duration
	animated_sprite2d.modulate = Color(1, 0.2, 0.2, 0.8)

func play_damage_sound():
	if playing_damage_sound:
		return
	if SoundManager:
		SoundManager.play("damage", 0.0, global_position)
		playing_damage_sound = true
		var length = SoundManager.sounds["damage"].get_length()
		get_tree().create_timer(length).timeout.connect(func():
			playing_damage_sound = false
		)
