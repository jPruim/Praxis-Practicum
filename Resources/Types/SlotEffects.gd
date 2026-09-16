class_name SlotEffects
extends Resource

enum EFFECT_KEY {
	FIRE,
	ICE,
}
const EFFECT_IMG_STR = {
	EFFECT_KEY.FIRE: "res://Assets/Spritesheets/IconArt/8bitfire-01.png"
}
@export var effects: Dictionary[EFFECT_KEY, int] = {
}

func _ready():
	reset_values()

## Reset each key value to zero
func reset_values() -> void:
	for key in EFFECT_KEY:
		effects[key] = 0
	

## Debug output, prints to command line if Global Debug mode
func print_debug():
	var output: String = "["
	for x in EFFECT_KEY:
		output += str(x) + " " + str(effects[x]) + ", "
	output += "]"
	if Globals.DEBUG:
		print(output)
	return(output)
	
