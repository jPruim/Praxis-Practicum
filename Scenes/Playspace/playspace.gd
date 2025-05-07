extends Node2D

#load
const cardBase = preload("res://Scenes/Cards/card_base.tscn")
var PlayerHand = preload("res://Scenes/Cards/player_hand.tscn")
const cardSize = Vector2(100,160)
var cardSelected = []
#var deckSize = 1
var playerHand
@onready var deckSize = 4


# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	#var playerHand = PlayerHand.instantiate()
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
