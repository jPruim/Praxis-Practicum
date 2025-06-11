extends Node2D

var player_cast_time = 0
var player_spell
var opponent_spell
var player_target
var opponent_target
var battle_manager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	battle_manager = $".."
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


	
func resolve_spells():
	var opponent_spell_ready = false
	var player_spell_ready = false
	if battle_manager.opponent_manager.cast_time == 0:
		opponent_spell_ready = true
		if opponent_target == "self":
			
			opponent_target = null
			pass
		elif opponent_target == "Player":
			
			opponent_target = null
			pass
		else:
			if (opponent_target.cards.size() > 0):
				var target = opponent_target.cards[0]
		
		
	if player_cast_time == 0:
		player_spell_ready = true
	
