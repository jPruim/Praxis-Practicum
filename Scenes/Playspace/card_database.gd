extends Node

const ICE = "ICE"
const FIRE = "FIRE"
const SHIELD = "SHIELD"
const NATURE = "NATURE"
const NEUTRAL = ""
var cards: Array[CardData] = []

#{
	#"Firebolt": ["Firebolt", "spell", 1, 0, 0, 4, FIRE, 0, "Deal 4 " + FIRE + " damage", "", false, 'single','single', [], 0],
	#"Arcane Barrier": ["Arcane", "spell", 1, 0, 0, 4, "", 0, "Gain 4 " + SHIELD + " damage", "", false, 'single','single', [], 0],
	#"Icebolt": ["Icebolt", "spell", 1, 0, 0, 4, ICE, 0, "Deal 4 " + ICE +  " damage", "", false, 'single','single', [], 0],
	#"Blank Spell": ["", "spell", 0, 0, 0, 0, "", 0, "", "", false, 'single','single', [], 0],
	#"Blank Summon": ["", "summon", 0, 1, 1, 0, "", 0, "", "", false, 'single','single', [], 0],
	#"Fire Fox": ["Fire Fox", "summon", 1, 3, 4, 0, FIRE, 0, "Stackable", "", true, 'single','single', [], 0],
	#"Bee": ["Bee", "summon", 0, 1, 1, 0, NEUTRAL, 0, "Attack matches Health. Stackable", "", true, 'single','single', [], 0],
	#"Snowy Owl": ["Snowy Owl", "summon", 0, 2, 4, 0, ICE, 2, "Also gains 2 shield. Stackable", "", true, 'single','single', [], 0],
#}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dir := DirAccess.open("res://Resources/Cards/")
	if dir == null: printerr("Could not open folder"); return
	dir.list_dir_begin()
	for file: String in dir.get_files():
		var resource := load(dir.get_current_dir() + "/" + file)
		cards.append(resource)
		print(resource)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
