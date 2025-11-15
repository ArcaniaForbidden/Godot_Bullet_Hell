extends CharacterBody2D

@onready var animated_sprite2d = $AnimatedSprite2D

@export var max_health: int = 50
@export var damage: int = 10
var health: int
var playing_damage_sound := false

func _ready():
	health = max_health
	animated_sprite2d.play("idle")

func take_damage(damage: int):
	play_damage_sound()
	health -= damage
	if health <= 0:
		die()

func die():
	queue_free()

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

func _on_area_2d_body_entered(player: Node2D) -> void:
	if player.is_in_group("player"):
		player.player_takes_damage(damage)
