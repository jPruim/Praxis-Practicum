class_name SpellManager
extends Node2D

var player_cast_time: int = 0
var player_spell: CardBase
var opponent_spell:CardBase
var player_target_slots: Array[CardSlot] = []
var opponent_target_slots: Array[CardSlot] = []
var battle_manager: BattleManager
var opponent_manager: OpponentManager
var card_manager: CardManager
var summon_base = preload("res://Scenes/Cards/summon_card_base.tscn")
var player_caster: CardSlot
var opponent_caster: CardSlot
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	battle_manager = $".."
	card_manager = $"../CardManager"
	SignalBus.opponent_targeting_player.connect(_on_opponent_targeting_player)
	SignalBus.opponent_targeting_self.connect(_on_opponent_targeting_self)
	SignalBus.opponent_targeting_slot.connect(_on_opponent_targeting_slot)
	SignalBus.player_targeting_opponent.connect(_on_player_targeting_opponent)
	SignalBus.player_targeting_self.connect(_on_player_targeting_self)
	SignalBus.player_targeting_slot.connect(_on_player_targeting_slot)
	player_caster = $"../Playspace/PlayerSlot"
	opponent_caster = $"../Playspace/OpponentSlot"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


	
func resolve_spells():
	# Initial setup 
	var opponent_spell_ready = false
	var player_spell_ready = false
	if opponent_spell && battle_manager.opponent_manager.cast_time == 0:
		opponent_spell_ready = true
		SignalBus.emit_signal("opponent_spell_resolution")
	if player_spell && player_cast_time == 0:
		player_spell_ready = true
		SignalBus.emit_signal("player_spell_resolution")
	
	# Summons First
	if opponent_spell_ready && opponent_spell.card_data.card_type == "summon":
		for slot in opponent_target_slots:
			resolve_spell_summon_at(opponent_spell, slot)
	if player_spell_ready && player_spell.card_data.card_type == "summon":
		for slot in player_target_slots:
			resolve_spell_summon_at(player_spell, slot)

	
	# Spell
	if opponent_spell_ready && opponent_spell.card_data.card_type == "spell":
		for slot in opponent_target_slots:
			resolve_spell_barrier_at(opponent_spell, slot)
	if player_spell_ready && player_spell.card_data.card_type == "spell":
		for slot in player_target_slots:
			resolve_spell_barrier_at(player_spell, slot)
	if opponent_spell_ready && opponent_spell.card_data.card_type == "spell":
		for slot in opponent_target_slots:
			resolve_spell_dmg_at(opponent_spell, slot)
	if player_spell_ready && player_spell.card_data.card_type == "spell":
		for slot in player_target_slots:
			resolve_spell_dmg_at(player_spell, slot)
			
	if opponent_spell_ready && opponent_spell.card_data.card_type == "spell":
		for slot in opponent_target_slots:
			resolve_spell_effects_at(opponent_spell, slot)
	if player_spell_ready && player_spell.card_data.card_type == "spell":
		for slot in player_target_slots:
			resolve_spell_effects_at(player_spell, slot)

	# Remove cast spells
	if player_spell && player_spell_ready:
		SignalBus.emit_signal("discard_card", player_spell)
		player_spell = null
		player_target_slots = []
	if opponent_spell && opponent_spell_ready:
		SignalBus.emit_signal("discard_card", opponent_spell)
		opponent_spell = null
		opponent_target_slots = []
	



# Create copy of spell as a summon card in slot
func resolve_spell_summon_at(spell: CardBase, slot: CardSlot):
	var summon: SummonCardBase = summon_base.instantiate()
	summon.copy(spell)
	SignalBus.emit_signal("discard_card", spell)
	card_manager.add_child(summon)
	slot.cards = [summon]
	summon.animate_card_to_slot(slot)
	slot.cards[0].card_data.current_health = summon.card_data.summon_health
	slot.cards[0].card_data.current_attack = summon.card_data.summon_attack
	slot.update_graphic()

func resolve_spell_barrier_at(spell:CardBase, slot: CardSlot):
	var block = spell.card_data.direct_block
	block += RelicManager.get_barrier_bonus()
	block = floor(block * RelicManager.get_barrier_mult())
	if ( slot.cards.size() > 0):
		slot.cards[0].card_data["current_block"] + block
		slot.update_graphic()
	pass

func resolve_spell_effects_at(spell:CardBase, slot: CardSlot):
	if spell.has_tag("fire"):
		slot.cards[0].add_effect("fire")
		slot.cards[0].remove_effect("ice")
	if spell.has_tag("ice"):
		slot.cards[0].add_effect("fire")
		slot.cards[0].remove_effect("ice")
	pass
	
func resolve_spell_dmg_at(spell:CardBase, slot: CardSlot):
	var dmg = spell.card_data.direct_damage
	dmg += RelicManager.get_spell_power_bonus()
	dmg = floor(dmg * RelicManager.get_spell_power_mult())
	if spell.has_tag("fire") && slot.cards[0].has_effect("ice"):
		dmg = dmg * RelicManager.get_melt_mult()
	elif spell.has_tag("ice") && slot.cards[0].has_effect("fire"):\
		dmg = dmg * RelicManager.get_melt_mult()
	if ( slot.cards.size() < 1):
		return
	slot.cards[0].adjust_health(-1 * dmg)
	slot.update_graphic()
	pass

func add_player_target(slot: CardSlot):
	player_target_slots.append(slot)
	pass
	
func add_opponent_target(slot):
	opponent_target_slots.append(slot)
	pass


# Signals
func _on_opponent_targeting_player(card):
	opponent_spell = card
	add_opponent_target(player_caster)

func _on_opponent_targeting_self(card: CardBase):
	opponent_spell = card
	add_opponent_target(opponent_caster)
	
func _on_opponent_targeting_slot(slot: CardSlot, card: CardBase):
	opponent_spell = card
	add_opponent_target(slot)

func _on_player_targeting_opponent(card: CardBase):
	player_spell = card
	add_player_target(opponent_caster)

func _on_player_targeting_self(card: CardBase):
	player_spell = card
	add_player_target(player_caster)
	
func _on_player_targeting_slot(slot: CardSlot, card: CardBase):
	player_spell = card
	add_player_target(slot)
	
func cast(card:CardBase, from_player: bool = false):
	var location
	if (from_player):
		location = Globals.PLAYER_CAST_POSITION
		card.z_index = Globals.Z_INDEX.card_cast_player
		$"../CardManager/PlayerHand".remove_card_from_hand(card)
		$"..".player_cast_time = card.card_data.cast_time
	else:
		location = Globals.ENEMY_CAST_POSITION
		card.z_index = Globals.Z_INDEX.card_cast_enemy
		$"../CardManager/OpponentHand".remove_card_from_hand(card)
	card.being_cast = true
	card.scale = Globals.SCALE.card_cast
	card.animate_card_to_position(location)
	card.animation_reveal()
	
