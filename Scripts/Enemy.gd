extends CharacterBody2D

@onready var animated_sprite2d = $AnimatedSprite2D

@export var max_health: int = 50
var health: int

func _ready():
	health = max_health
	animated_sprite2d.play("idle")

func apply_damage(damage: int):
	health -= damage
	if health <= 0:
		die()

func die():
	queue_free()
