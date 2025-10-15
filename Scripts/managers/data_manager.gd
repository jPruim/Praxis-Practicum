extends Node2D

var save_file: String = "user://savefile.tres"
var achievement_file: String
var default_save_file: String = "res://Resources/GameData/default_game.tres"
var debug_summon_file: String = "res://Resources/GameData/summon_test.tres"
const RunDataPS = preload("res://Resources/Types/RunData.gd") # PackedScene
const CardDataPS = preload("res://Resources/Types/CardData.gd") # PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func load_game_data():
	var run_data: RunData
	if FileAccess.file_exists(save_file):
		var file = FileAccess.open(save_file, FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		return run_data_deJSONIFY(data)
	else:
		run_data = load_default_game_data()
		save_game(run_data)
		return run_data

func save_game(run_data: RunData):
	var file = FileAccess.open(save_file, FileAccess.WRITE)
	file.store_line(JSON.stringify(run_data_JSONIFY(run_data)))

func load_default_game_data():
	if(Globals.DEBUG):
		if(Globals.DEBUG_TYPE.summon):
			return load_saved_static_resource(debug_summon_file)
	return load_saved_static_resource(default_save_file)

func load_saved_static_resource(path: String):
	if ResourceLoader.exists(path):
		return load(path)
	printerr("Loading null game data")
	get_tree().quit()

func load_enemy_game_data(enemy: int = 1):
	var path
	if (enemy == 1):
		path = "res://Resources/GameData/first-fight.tres"
	else:
		path = "res://Resources/GameData/default-enemy.tres"
	return load_saved_static_resource(path)

func run_data_JSONIFY(run_data: RunData):
	var run_json = {}
	run_json['seed'] = run_data.seed
	run_json['event'] = run_data.event
	run_json['gold'] = run_data.gold
	run_json['max_health'] = run_data.max_health
	run_json['current_health'] = run_data.current_health
	run_json['relics'] = run_data.relics
	run_json['deck'] = []
	for x in run_data.deck:
		run_json['deck'].append(card_data_JSONIFY(x))
	run_json['assignment'] = run_data.assignment
	run_json['phase'] = run_data.phase
	run_json['assignment_list'] = run_data.assignment_list
	run_json['ascension'] = run_data.ascension
	return run_json
	
func run_data_deJSONIFY(run_json):
	var run_data: RunData = RunDataPS.new()
	run_data['seed'] = run_json.seed
	run_data['event'] = run_json.event
	run_data['gold'] = run_json.gold
	run_data['max_health'] = run_json.max_health
	run_data['current_health'] = run_json.current_health
	run_data['relics'] = run_json.relics
	run_data['deck'] = []
	for x in run_json.deck:
		run_data['deck'].append(card_data_deJSONIFY(x))
	run_data['assignment'] = run_json.assignment
	run_data['phase'] = run_json.phase
	run_data['assignment_list'] = run_json.assignment_list
	run_data['ascension'] = run_json.ascension
	return run_json

func print_run_data(run_data: RunData):
	print(JSON.stringify(run_data_JSONIFY(run_data)))

func card_data_JSONIFY(card_data: CardData):
	var card_json = {}
	card_json['display_name'] = card_data['display_name']
	card_json['card_type'] = card_data['card_type']
	card_json['cast_time'] = card_data['cast_time']
	card_json['summon_attack'] = card_data['summon_attack']
	card_json['summon_health'] = card_data['summon_health']
	card_json['direct_damage'] = card_data['direct_damage']
	card_json['direct_block'] = card_data['direct_block']
	card_json['card_text'] = card_data['card_text']
	card_json['animation'] = card_data['animation']
	card_json['stackable'] = card_data['stackable']
	card_json['ally_target'] = card_data['ally_target']
	card_json['enemy_target'] = card_data['enemy_target']
	card_json['current_block'] = card_data['current_block']
	card_json['current_health'] = card_data['current_health']
	card_json['current_attack'] = card_data['current_attack']
	card_json['effects'] = card_data['effects']
	card_json['effect_strength'] = card_data['effect_strength']
	card_json['spell_level'] = card_data['spell_level']
	card_json['tags'] = card_data['tags']
	return card_json
	
func card_data_deJSONIFY(card_json):
	var card_data: CardData = CardDataPS.new()
	card_data['display_name'] = card_json['display_name']
	card_data['card_type'] = card_json['card_type']
	card_data['cast_time'] = card_json['cast_time']
	card_data['summon_attack'] = card_json['summon_attack']
	card_data['summon_health'] = card_json['summon_health']
	card_data['direct_damage'] = card_json['direct_damage']
	card_data['direct_block'] = card_json['direct_block']
	card_data['card_text'] = card_json['card_text']
	card_data['animation'] = card_json['animation']
	card_data['stackable'] = card_json['stackable']
	card_data['ally_target'] = card_json['ally_target']
	card_data['enemy_target'] = card_json['enemy_target']
	card_data['current_block'] = card_json['current_block']
	card_data['current_health'] = card_json['current_health']
	card_data['current_attack'] = card_json['current_attack']
	card_data['effects'] = card_json['effects']
	card_data['effect_strength'] = card_json['effect_strength']
	card_data['spell_level'] = card_json['spell_level']
	card_data['tags'] = card_json['tags']
	return card_data
