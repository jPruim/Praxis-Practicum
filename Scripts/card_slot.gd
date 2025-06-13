extends Node2D

class_name CardSlot


# Constants
const SLOT_SCALE = Vector2(0.9, 0.9)

# Properties
var cards = []
var max_cards = 1
var player_owned = false # True if the owner is the player
var is_player = false # True if the card slot is representing the player
var is_opponent = false # True if the card slot is representing the opponent


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".scale = SLOT_SCALE
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
