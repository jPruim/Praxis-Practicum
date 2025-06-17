extends Node2D

var player_cast_time = 0
var player_spell
var opponent_spell
var player_target_slots
var opponent_target_slots
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
	if opponent_spell && battle_manager.opponent_manager.cast_time == 0:
		opponent_spell_ready = true
		if opponent_target_slots.size() > 0:
			for slot in opponent_target_slots:
				resolve_spell_at(opponent_spell, slot)
			opponent_target_slots = null
	if player_spell && player_cast_time == 0:
		opponent_spell_ready = true
		if player_target_slots.size() > 0:
			for slot in player_target_slots:
				resolve_spell_at(player_spell, slot)
			player_target_slots = null


func resolve_spell_at(spell, slot):
	pass
