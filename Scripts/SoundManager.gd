extends Node2D

var master_volume_percentage: int = 100
var sound_volume_percentage: int = 100
var music_volume_percentage: int = 100

var current_hover_player: AudioStreamPlayer = null
var sounds = {
	"damage": preload("res://Sounds/damage.wav"),
	"player_hurt": preload("res://Sounds/player_hurt.wav"),
}

func play(sound_name: String, base_volume_db: float = 0.0, sound_position = null) -> void:
	if not sounds.has(sound_name):
		return
	var sfx
	if position != null:
		sfx = AudioStreamPlayer2D.new()
		sfx.position = sound_position
		sfx.attenuation = 0.5
	else:
		sfx = AudioStreamPlayer.new()
	sfx.stream = sounds[sound_name]
	var category_volume_pct: int
	if sound_name in []: # example music
		category_volume_pct = music_volume_percentage
	else:
		category_volume_pct = sound_volume_percentage
	var final_volume_db = base_volume_db + percent_to_db(master_volume_percentage) + percent_to_db(category_volume_pct)
	sfx.volume_db = final_volume_db
	add_child(sfx)
	sfx.play()

# Converts 0-100% to Godot dB (-30dB to 0dB)
func percent_to_db(pct: float) -> float:
	return lerp(-30.0, 0.0, clampf(pct, 0, 100) / 100.0)
