extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# String Format guide: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_format_string.html
func get_replacements(player_name: String = "V", enemy_name: String = "E", dmg:int = 0) -> Dictionary:
	var replacements = {
		"fire": "FIRE",
		"ice": "ICE",
		"barrier": "BARRIER",
		"dmg": dmg,
	}
	
	return replacements
	
	
