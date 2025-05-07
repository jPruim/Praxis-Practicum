extends Node2D



# Consts
const CARD_SCENE_PATH = "res://Scenes/Cards/card_base.tscn"
const CARD_DRAW_ASPEED = 0.2 # animation speed
# Properties
var player_deck = ["Knight", "Knight", "Knight"]
var card_scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_scene = preload(CARD_SCENE_PATH)
	$DeckCount.text = str(player_deck.size())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func draw_card():
	# "Draw the card"
	var card_drawn = player_deck[0]
	player_deck.erase(card_drawn)
	$DeckCount.text = str(player_deck.size())


	# Handle a just emptied deck
	if player_deck.size() == 0:
		hide_deck()
		
	# Create the card that was drawn
	var new_card = card_scene.instantiate()
	# Set card origin to deck position
	new_card.position = $".".position
	$"../CardManager".add_child(new_card)
	new_card.name =  "Card"
	$"../PlayerHand".add_card_to_hand(new_card, CARD_DRAW_ASPEED)
	pass # Replace with function body.

# Remove all visible parts of the deck
func hide_deck():
	$Area2D/CollisionShape2D.disabled = true
	$Sprite2D.visible = false
	$DeckCount.visible = false
