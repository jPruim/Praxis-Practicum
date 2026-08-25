extends Node2D
## initially pulled from https://github.com/Aarimous/AudioManager


## Audio manager node. Inteded to be globally loaded as a 2D Scene. Handles [method create_2d_audio_at_location()] and [method create_audio()] to handle the playback and culling of simultaneous sound effects.
##
## To properly use, define [enum SoundEffect.SOUND_EFFECT_TYPE] for each unique sound effect, create a Node2D scene for this AudioManager script add those SoundEffect resources to this globally loaded script's [member sound_effects], and setup your individual SoundEffect resources. Then, use [method create_2d_audio_at_location()] and [method create_audio()] to play those sound effects either at a specific location or globally.
## 
## See https://github.com/Aarimous/AudioManager for more information.
##
## @tutorial: https://www.youtube.com/watch?v=Egf2jgET3nQ

var sound_effect_dict: Dictionary = {} ## Loads all registered SoundEffects on ready as a reference.
const DEFAULT_LOCATION = Vector2(-100,-100)
@export var sound_effects: Array[SoundEffect] ## Stores all possible SoundEffects that can be played.


func _ready() -> void:
	for sound_effect: SoundEffect in sound_effects:
		sound_effect_dict[sound_effect.type] = sound_effect
	SignalBus.connect("trigger_sound", start_sound)


## Creates a sound effect at a specific location if the limit has not been reached. 
func create_2d_audio_at_location(type: SoundEffect.SOUND_EFFECT_TYPE, location: Vector2, is_music:bool = false) -> void:
	if sound_effect_dict.has(type):
		var sound_effect: SoundEffect = sound_effect_dict[type]
		if sound_effect.has_open_limit():
			sound_effect.change_audio_count(1)
			var new_2D_audio: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
			add_child(new_2D_audio)
			if is_music:
				new_2D_audio.bus = "Background Music"
			else:
				new_2D_audio.bus = "SFX"
			new_2D_audio.position = location
			new_2D_audio.stream = sound_effect.sound_effect
			new_2D_audio.volume_db = sound_effect.volume
			new_2D_audio.pitch_scale = sound_effect.pitch_scale
			new_2D_audio.pitch_scale += randf_range(-sound_effect.pitch_randomness, sound_effect.pitch_randomness )
			new_2D_audio.finished.connect(sound_effect.on_audio_finished)
			# handle looping #ineffectual atm
			if(sound_effect.loop):
				trigger_sound(type, location)
			new_2D_audio.finished.connect(new_2D_audio.queue_free)
			new_2D_audio.play()
	else:
		push_error("Audio Manager failed to find setting for type ", type)


## Creates a sound effect if the limit has not been reached. Pass [param type] for the SoundEffect to be queued.
func create_audio(type: SoundEffect.SOUND_EFFECT_TYPE, is_music:bool = false) -> void:
	if sound_effect_dict.has(type):
		var sound_effect: SoundEffect = sound_effect_dict[type]
		if sound_effect.has_open_limit():
			sound_effect.change_audio_count(1)
			var new_audio: AudioStreamPlayer = AudioStreamPlayer.new()
			add_child(new_audio)
			if is_music:
				new_audio.bus = "Background Music"
			else:
				new_audio.bus = "SFX"
			new_audio.stream = sound_effect.sound_effect
			new_audio.volume_db = sound_effect.volume
			new_audio.pitch_scale = sound_effect.pitch_scale
			new_audio.pitch_scale += randf_range(-sound_effect.pitch_randomness, sound_effect.pitch_randomness)
			new_audio.finished.connect(sound_effect.on_audio_finished)
			# handle looping #ineffectual atm
			if(sound_effect.loop):
				trigger_sound(type)
			new_audio.finished.connect(new_audio.queue_free)
			new_audio.play()
	else:
		push_error("Audio Manager failed to find setting for type ", type)
	
## Create sound from signal	
func start_sound(type: SoundEffect.SOUND_EFFECT_TYPE, location: Vector2 = DEFAULT_LOCATION, is_music:bool = false):
	if location == DEFAULT_LOCATION:
		create_audio(type, is_music)
	else:
		create_2d_audio_at_location(type, location, is_music)

## emit sound trigger
func trigger_sound(type: SoundEffect.SOUND_EFFECT_TYPE, location: Vector2 = DEFAULT_LOCATION, is_music: bool = false):
	SignalBus.emit_signal("trigger_sound", type, location, is_music)
