extends Node2D



# Consts
const CARD_SCENE_PATH = "res://Scenes/Cards/card_base.tscn"
const CARD_DRAW_ASPEED = 0.2 # animation speed
const CARD_SPAWN = Vector2(-300,-300)
# Properties
var player_deck = [] # Array of JSON Card Info
var card_scene
var card_database

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_scene = preload(CARD_SCENE_PATH)
	$DeckCount.text = str(player_deck.size())
	card_database = preload("res://Scripts/CardDatabase.gd")
	# Initialize the deck
	initialize_deck()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func draw_card():
	# "Draw the card"
	var card_drawn = player_deck.pop_front()
	#player_deck.erase(card_drawn)
	$DeckCount.text = str(player_deck.size())


	# Handle a just emptied deck
	if player_deck.size() == 0:
		hide_deck()
		
	# Add Card to hand
	card_drawn.position = $".".position
	$"../PlayerHand".add_card_to_hand(card_drawn, CARD_DRAW_ASPEED)
	# Reveal Card
	card_drawn.animation_reveal()
	pass # Replace with function body.

# Remove all visible parts of the deck
func hide_deck():
	$Area2D/CollisionShape2D.disabled = true
	$Sprite2D.visible = false
	$DeckCount.visible = false

# Undo hide_deck()
func reveal_deck():
	$Area2D/CollisionShape2D.disabled = false
	$Sprite2D.visible = true
	$DeckCount.visible = true
	

# Initialize deck
func initialize_deck():
	player_deck = []
	for key in card_database.CARDS.keys():
		#card_database
		add_card_to_deck(card_database.CARDS[key])
		pass
	player_deck.shuffle()
	$DeckCount.text = str(player_deck.size())

# Add Card to Deck, Accepts Array
func add_card_to_deck(data):
	var new_card = card_scene.instantiate()
	new_card.position = CARD_SPAWN
	new_card.set_all(data)
	$"../CardManager".add_child(new_card)
	player_deck.append(new_card)
