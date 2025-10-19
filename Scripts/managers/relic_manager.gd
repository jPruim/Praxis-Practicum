extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_barrier_bonus() -> int:
	var bonus = 0;
	bonus += get_spell_power_bonus()
	return bonus
	
func get_barrier_mult() -> float:
	var mult = 1
	
	return 1
	
func get_spell_power_bonus() -> int:
	return 0
	
# No plan to add atm
func get_spell_power_mult() -> float:
	return 1
	
func get_summon_bonus_health() -> int:
	return 0
	
func get_summon_bonus_attack() -> int:
	return 0

func get_melt_mult() -> float:
	return 2
