extends Node2D



# Consts
const CARD_SCENE_PATH = "res://Scenes/Cards/card_base.tscn"
const CARD_DRAW_ASPEED = 0.2 # animation speed
const CARD_SPAWN = Vector2(-300,-300)

# Properties
var hand_limit = 6 # Note this is a var as it might be changed over the course of game
var ai_deck = true # Check if the deck is NOT owned by the player
var deck = [] # Array of JSON Card Info
var card_scene
var card_database
var valid_draw = true # Check if a card can be drawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_scene = preload(CARD_SCENE_PATH)
	$DeckCount.text = str(deck.size())
	card_database = preload("res://Scripts/CardDatabase.gd")
	# Initialize the deck ai_deck is assigned in the parent _ready() function
	initialize()
	pass # Replace with function body.



func initialize(hand_size = 5):
	if ai_deck:
		initialize_enemy()
	else:
		initialize_player(hand_size)
		#$"../PlayerHand"

# Setup function for AI
func initialize_enemy( type: int = 0):
	initialize_enemy_deck(type)
	pass

# TODO: Make this different from player deck
func initialize_enemy_deck(type: int = 0):
	initialize_player_deck()
	
# Setup function for the player
func initialize_player(hand_size = 5):
	initialize_player_deck()
	initialize_player_hand(hand_size)
	
# Setup function for the player's hand
func initialize_player_hand(hand_size = 5):
	for i in range(hand_size):
		draw_card()
	#$"../../PlayerHand".update_hand_positions()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func draw_card():
	# Handle cases where deck shouldn't draw
	if (!valid_draw):
		return
	# Check if the hand is full
	if (ai_deck):
		if ($"../../OpponentHand".player_hand.size() > hand_limit - 1):
			return
	if ($"../../PlayerHand".player_hand.size() > hand_limit - 1):
		return
	# "Draw the card"
	var card_drawn = deck.pop_front()
	if(!card_drawn):
		# Deck is empty
		return
	$DeckCount.text = str(deck.size())


	# Handle a just emptied deck
	if deck.size() == 0:
		hide_deck()
	card_drawn.position = $".".position
	# Add Card to hand
	if (ai_deck):
		$"../../OpponentHand".add_card_to_hand(card_drawn, CARD_DRAW_ASPEED)
	else:
		$"../../PlayerHand".add_card_to_hand(card_drawn, CARD_DRAW_ASPEED)
		# Reveal Card
		card_drawn.animation_reveal()
	pass

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
func initialize_player_deck():
	if (ai_deck):
		return
	deck = []
	
	#initialize deck
	for i in range (0,2):
		for key in card_database.CARDS.keys():
			#card_database
			add_card_to_deck(card_database.CARDS[key])
			pass
	deck.shuffle()
	$DeckCount.text = str(deck.size())

# Add Card to Deck, Accepts Array
func add_card_to_deck(data):
	var new_card = card_scene.instantiate()
	new_card.position = CARD_SPAWN
	new_card.set_all(data)
	$"..".add_child(new_card)
	deck.append(new_card)
