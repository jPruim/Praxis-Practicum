class_name Damage
extends Resource

@export var dmg: int = 0
@export var dmg_type: String = "Arcane"
@export var source: String = "Summon"

func print_debug():
	var output: String = "["
	output += str(dmg) 
	output += ": "
	output += dmg_type
	output += source
	output += "]"
	if Globals.DEBUG:
		print(output)
	return(output)
	
