class_name Target
extends Node2D

var ai:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func display_player_target():
	$Sprite.texture = load("res://Assets/GUI/target-blue.png")
	ai = false
	
func display_enemy_target():
	$Sprite.texture = load("res://Assets/GUI/target.png")
	ai = true

	
