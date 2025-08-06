extends Node

# Global Constants
const VIEWPORT_SIZE = Vector2(1920,1080)
const DEBUG = false

# Card Info order
enum CARD_INFO { DISPLAY_NAME, CARD_TYPE, CAST_TIME, SUMMON_ATTACK, SUMMON_HEALTH, DIRECT_DAMAGE, DAMAGE_TYPE, DIRECT_BLOCK, CARD_TEXT, ANIMATION, STACKABLE, ALLY_TARGET, ENEMY_TARGET, EFFECTS, EFFECT_STRENGTH}

# Key words
const KEY = {
	'FIRE': "FIRE",
	'ICE': "ICE",
	'ARCANE': "ARCANE",
	'BLOCK': "BLOCK",
	'DELAY': "DELAY",
	'MANABURN': "MANABURN"
}

# Z_index
const Z_INDEX = {
	"background": -100,
	"deck": -5,
	"card_animation": 0,
	"card_in_slot": 1,
	"caster_frame": 5,
	"card_cast_player":6,
	"hand": 10,
	"card": 15,
	"card_cast_enemy": 16,
	"card_back": 20,
	"card_hovered": 25,
	"card_being_dragged": 30,
	"centerpoint": 35
}

# Masks
const MASK = {
	"card": 1,
	"cardSlot": 2,
	"deck_player": 4,
	"deck_opponent": 8,
	"card_opponent":16,
	"player_hand": 32,
}

# Graphic Constants
const DECK_POSITION = Vector2(100, 900)
const OPPONENT_DECK_POSITION = Vector2(1800, 150)
const CARD_SCALE_PlACED = Vector2( 0.7, 0.7)
const DEFAULT_ASPEED = 0.25
const PLAYER_POSITION = Vector2((VIEWPORT_SIZE/ 2).x, 850)
const ENEMY_POSITION = Vector2((VIEWPORT_SIZE/ 2).x, 125)
const PLAYER_CAST_POSITION = PLAYER_POSITION + Vector2(75,0)
const ENEMY_CAST_POSITION = ENEMY_POSITION + Vector2(75,0)
const CAST_SCALE = Vector2(0.45, 0.45)

const SCALE = {
	"card_placed": Vector2(0.7, 0.7),
	"card_cast": Vector2(0.5, 0.5),
	"card_hovered": Vector2(1.05, 1.05),
	"card": Vector2(1,1),
	"card_hand": Vector2(1,1),
	"card_drag": Vector2(1,1),
}



const PLAYER_HAND_Y_POS = 1150
const OPPONENT_HAND_Y_POS = -80

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
