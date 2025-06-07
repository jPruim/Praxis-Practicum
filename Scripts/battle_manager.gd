extends Node2D


var target_scene
var current_target
var opponent_manager
var in_combat = false
var player_cast_time
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_scene = preload("res://Scenes/Graphic Elements/target.tscn")
	opponent_manager = $"../OpponentManager"
	SignalBus.opponent_targeting_player.connect(_on_opponent_targeting_player)
	SignalBus.opponent_targeting_self.connect(_on_opponent_targeting_self)
	SignalBus.opponent_targeting_slot.connect(_on_opponent_targeting_slot)
	SignalBus.player_targeting_player.connect(_on_player_targeting_player)
	SignalBus.player_targeting_self.connect(_on_player_targeting_self)
	SignalBus.player_targeting_slot.connect(_on_player_targeting_slot)
	setup_combat()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func setup_combat(enemy):
	opponent_manager.identify_slots()
	in_combat = true	
	

func _on_pass_button_pressed() -> void:
	increment_time()


func increment_time():
	if(opponent_manager.cast_time == 0):
		opponent_manager.make_ai_play()
	if(player_cast_time)

func opponent_turn():
		# Make the button unclickable and invisible
	$"../PassButton".disabled = true
	$"../PassButton".visible = false
	# Initialize Opponent Turn
	$"../OpponentManager".start_turn()
	$"../OpponentManager".end_turn()

func play_card(card, caster = "player", cardslot = "", player = "opponent", cast_time_mod = 0, cast_damage_mod = 0):
	pass

func player_turn():
	$"../PassButton".visible = true
	$"../PassButton".disabled = false


func _on_opponent_targeting_player(card):
	if current_target:
		current_target.free()
	current_target = target_scene.instantiate()
	current_target.position = Globals.PLAYER_POSITION
	$".".add_child(current_target)

func _on_opponent_targeting_self(card):
	if current_target:
		current_target.free()
	current_target = target_scene.instantiate()
	current_target.position = Globals.ENEMY_POSITION
	$".".add_child(current_target)
	
func _on_opponent_targeting_slot(slot, card):
	if current_target:
		current_target.free()
	current_target = target_scene.instantiate()
	current_target.position = slot.position
	$".".add_child(current_target)

func _on_player_targeting_player(card):
	if current_target:
		current_target.free()
	current_target = target_scene.instantiate()
	current_target.position = Globals.PLAYER_POSITION
	$".".add_child(current_target)

func _on_player_targeting_self(card):
	if current_target:
		current_target.free()
	current_target = target_scene.instantiate()
	current_target.position = Globals.ENEMY_POSITION
	$".".add_child(current_target)
	
func _on_player_targeting_slot(slot, card):
	if current_target:
		current_target.free()
	current_target = target_scene.instantiate()
	current_target.position = slot.position
	$".".add_child(current_target)
