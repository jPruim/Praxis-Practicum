extends Node2D

class_name CardSlot



# Properties
var cards: Array[CardBase] = []
var max_cards = 1
var player_owned = false # True if the owner is the player
var is_player = false # True if the card slot is representing the player
var is_opponent = false # True if the card slot is representing the opponent


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".scale = Globals.SCALE.card
	$".".z_index = Globals.Z_INDEX.card_in_slot - 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

func set_animation_position():
	$CardFront/Container/AnimatedSprite2D.position.y = 100
