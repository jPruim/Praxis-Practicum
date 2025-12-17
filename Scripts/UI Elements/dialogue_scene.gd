class_name DialogueScene
extends CanvasLayer

# Based on https://github.com/stevepixelface/dialog-system/

var scene_text = {}
var selected_text = []
var in_progress = false
var dialogue_json: JSON

var speaker_label_offset = 75
var dialogue_opacity = "ffffffb4" # 180 out of 255
var a_reveal_speed = 0.1

@onready var background = $Background
@onready var dialogue_text = $Background/MarginContainer/DialogueText
@onready var speaker_label = $SpeakerLabel

func _ready():
	animationless_hide()
	position_elements()
	scene_text = load_scene_text()
	#SignalBus.connect("display_dialog", self, "on_display_dialog")

func load_scene_text():
	dialogue_json = DataManager.load_dialogue_data()
#
func show_text():
	dialogue_text.text = selected_text.pop_front()

func next_line():
	if selected_text.size() > 0:
		show_text()
	else:
		finish()
#
func finish():
	dialogue_text.text = ""
	background.visible = false
	in_progress = false
	get_tree().paused = false

func on_display_dialog(text_key):
	if in_progress:
		next_line()
	else:
		get_tree().paused = true
		background.visible = true
		in_progress = true
		selected_text = scene_text[text_key].duplicate()
		show_text()

func animationless_hide():
	background.visible = false
	speaker_label.visible = false

func position_elements(player_speaking: bool = false):
	background.position = Vector2(Globals.VIEWPORT_SIZE.x /2, 50)
	var new_position =  Vector2(background.position.x, background.position.y + background.size.y)
	if player_speaking:
		new_position.x -= speaker_label_offset
	else:
		new_position.x += speaker_label_offset
	speaker_label.position = new_position

func animation_reveal(player_speaking: bool = false):
	position_elements()
	var tween = get_tree().create_tween()
	$".".modulate = "ffffff00"
	tween.tween_property($".", "modulate", dialogue_opacity, a_reveal_speed)
	
