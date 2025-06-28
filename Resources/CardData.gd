class_name CardData
extends Resource

@export var display_name: String = "Blank Spell"
@export var card_type: String = "Blank"
@export var cast_time: int = 0
@export var summon_attack: int = 0
@export var summon_health: int = 0
@export var direct_damage: int = 0
@export var damage_type: String = ""
@export var direct_block: int = 0
@export var card_text: String = "Do nothing."
@export var animation: String = ""
@export var stackable: bool = false
@export var ally_target: String = "Single"
@export var enemy_target: String = "Single"
@export var effects: Array[String] = []
@export var effect_strength: int = 0
@export var spell_level : int = 1
@export var spell_rarity : String = "Common"
