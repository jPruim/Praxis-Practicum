extends Node

# Global Constants

# Card Info order
enum CARD_INFO { DISPLAY_NAME, CARD_TYPE, CAST_TIME, SUMMON_ATTACK, SUMMON_HEALTH, DIRECT_DAMAGE, DAMAGE_TYPE, DIRECT_BLOCK, CARD_TEXT, ANIMATION, STACKABLE}

# Z_index
const Z_INDEX = {
	"background": -100,
	"deck": -5,
	"card_animation": 0,
	"card_in_slot": 1,
	"card": 4,
	"card_back": 5,
	"card_hovered": 10,
	"card_being_dragged": 11,
	"centerpoint": 15
}

# Masks
const CARD_COLLISION_MASK = 1
const CARD_SLOT_COLLISION_MASK = 2
const DECK_COLLISION_MASK = 4
const DECK_COLLISION_MASK_OPPONENT = 8
const CARD_COLLISION_MASK_OPPONENT = 16

# Graphic Constants
const DECK_POSITION = Vector2(100, 900)
const OPPONENT_DECK_POSITION = Vector2(1800, 150)
const CARD_SCALE_PlACED = Vector2( 0.7, 0.7)
const DEFAULT_ASPEED = 0.25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
