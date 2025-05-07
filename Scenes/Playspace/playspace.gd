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

#func _input(event: InputEvent) -> void:
	#
	##mouse events
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			#var newCard = cardBase.instantiate()
			#cardSelected = randi() % deckSize
			#print(cardSelected)
			#newCard.dbCardName = playerHand.cardList[cardSelected]
			#newCard.position = get_global_mouse_position()
			#newCard.scale = (cardSize)/newCard.size
			#print(newCard.size)
			#$Cards.add_child(newCard)
			#playerHand.cardList.erase(playerHand.cardList[cardSelected])
			#deckSize -= 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
