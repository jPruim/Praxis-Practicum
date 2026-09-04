class_name Damage
extends Resource

@export var dmg: int = 0
@export var dmg_type: String = "ARCANE"
@export var source: String = "SUMMON"

## Set dmg value (int). Can't be negative
func set_dmg(val: int = 0):
	if val < 0:
		val = 0
	dmg = val


## Change dmg type, unlikely to be needed
func set_dmg_type(val: String = "ARCANE"):
	if val == "FIRE":
		dmg_type = val
	elif val == "ICE":
		dmg_type = val
	else:
		dmg_type = "ARCANE"

## Change source tag. Unlikely to be needed
func set_source(val: String):
	if val == "SUMMON":
		source = val
	elif val == "SPELL":
		source = val
	elif val == "PASSIVE":
		source = val
	elif val == "RELIC":
		source = val
	else:
		source = "BLANK"
		printerr("Blank Damage source")
		
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
	
