extends CharacterBody2D

@export var max_health: int = 50
var health: int

func _ready():
	health = max_health

func apply_damage(damage: int):
	health -= damage
	if health <= 0:
		die()

func die():
	queue_free()
