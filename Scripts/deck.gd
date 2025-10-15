extends Node2D



# Consts
const CARD_SCENE_PATH = "res://Scenes/Cards/card_base.tscn"
const SPELL_SCENE_PATH = "res://Scenes/Cards/spell_card_base.tscn"
const SUMMON_SCENE_PATH = "res://Scenes/Cards/summon_card_base.tscn"
const CARD_DRAW_ASPEED = 0.2 # animation speed
const CARD_SPAWN = Vector2(-300,-300)

# Properties
var hand_limit = 6 # Note this is a var as it might be changed over the course of game
var ai_deck = true # Check if the deck is NOT owned by the player
var run_deck : Array[CardData] = []
var deck: Array[CardBase] = []
var discard_pile: Array[CardBase] = []
var card_scene
var spell_scene
var summon_scene
var card_database
var valid_draw = true # Check if a card can be drawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_scene = preload(CARD_SCENE_PATH)
	spell_scene = preload(SPELL_SCENE_PATH)
	summon_scene = preload(SUMMON_SCENE_PATH)
	$DeckCount.text = str(deck.size())
	# Initialize the deck ai_deck is assigned in the parent _ready() function
	# initialize()
	pass # Replace with function body.



func initialize(run_data: RunData, handsize: int = 5):
	card_scene = preload(CARD_SCENE_PATH)
	
	card_database = CardDatabase
	if ai_deck:
		initialize_enemy(run_data)
	else:
		initialize_player(run_data, handsize)
		#$"../PlayerHand"

# Setup function for AI
func initialize_enemy( run_data: RunData, hand_size = 5):
	# get enemy type, adjusting for the 1-indexed assignment variable
	var type = run_data.assignment_list[run_data.assignment -1]
	initialize_enemy_deck(type)
	initialize_player_hand(hand_size)
	pass


func initialize_enemy_deck(type: int = 1):
	# TODO: handle different enemies
	var enemy_data: RunData = DataManager.load_enemy_game_data(type)
	var enemy_deck = enemy_data['deck']
	# initialize deck
	for i in range (0,2):
		for data in enemy_deck:
			add_card_to_deck(data)
			pass
	deck.shuffle()
	$DeckCount.text = str(deck.size())

	
# Setup function for the player
func initialize_player(run_data, hand_size: int = 5):
	run_deck = run_data.deck
	initialize_player_deck()
	initialize_player_hand(hand_size)
	
# Setup function for the player's hand
func initialize_player_hand(hand_size = 5):
	for i in range(hand_size):
		draw_card()
	#$"../../PlayerHand".update_hand_positions()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

func draw_card():
	# Handle cases where deck shouldn't draw
	if (!valid_draw):
		return
	# Check if the hand is full
	if (ai_deck):
		if ($"../OpponentHand".player_hand.size() > hand_limit - 1):
			return
	if ($"../PlayerHand".player_hand.size() > hand_limit - 1):
		return
	# "Draw the card"
	var card_drawn = deck.pop_front()
	if(!card_drawn):
		# Deck is empty
		if(discard_pile.size() > 0):
			reshuffle_deck()
		else:
			# Deck is empty
			SignalBus.emit_signal("fight_loss")
		return
	$DeckCount.text = str(deck.size())


	# Handle a just emptied deck
	if deck.size() == 0:
		hide_deck()
	card_drawn.position = $".".position
	# Add Card to hand
	if (ai_deck):
		$"../OpponentHand".add_card_to_hand(card_drawn, CARD_DRAW_ASPEED)
	else:
		$"../PlayerHand".add_card_to_hand(card_drawn, CARD_DRAW_ASPEED)
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
	#initialize deck
	for i in range (0,1):
		for data in run_deck:
			#card_database
			add_card_to_deck(data)
			pass
	deck.shuffle()
	$DeckCount.text = str(deck.size())

# Add Card to Deck, Accepts Array
func add_card_to_deck(data: CardData):
	var new_card: CardBase
	if(data.card_type == "summon"):
		new_card = summon_scene.instantiate()
	else:
		new_card = spell_scene.instantiate()
	new_card.position = CARD_SPAWN
	new_card.set_all(data)
	new_card.set_display(data)
	if(ai_deck):
		new_card.ai_card = true
		new_card.get_node("Area2D").collision_mask = Globals.MASK.card + Globals.MASK.card_opponent
	$"..".add_child(new_card)
	deck.append(new_card)

func reshuffle_deck():
	deck = discard_pile
	deck.shuffle()
	discard_pile = []
	SignalBus.emit_signal("shuffle_deck")
