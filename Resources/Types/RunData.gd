class_name RunData
extends Resource

@export var seed: int = 0
@export var event: int = 1
@export var gold: int = 0
@export var max_health: int = 100
@export var current_health: int = 100
@export var relics: Array[Relic] = []
@export var deck: Array[CardData] = []
@export var assignment: int = 0 # Not zero indexed, 0 is pregame
@export var phase: String = ""
@export var assignment_list: Array[int] = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ]
@export var ascension : int = 0
