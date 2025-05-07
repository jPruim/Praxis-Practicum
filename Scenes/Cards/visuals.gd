extends MarginContainer

var cardDatabase = preload("res://Assets/Cards/CardsDatabase.gd")
@export var dbCardName = 'Archer'
@onready var cardInfo = cardDatabase.DATA[cardDatabase[dbCardName]]
@onready var cardImgStr = str("res://Assets/Cards/",cardInfo[0],'/',dbCardName,'.png')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(cardInfo)
	var cardSize = size #from property CardBase.size (visible in 2d layout properties)
	if $Border: 
		$Border.scale *=cardSize/$Border.texture.get_size()
	$CardArt.texture = load(cardImgStr)
	if $CardArt: 
		$CardArt.scale *=cardSize/$CardArt.texture.get_size()
	var cardName = str("", cardInfo[cardDatabase.CARDNAME])
	var cardAttack = str("", cardInfo[cardDatabase.CARDATTACK])
	var cardType = str("",cardInfo[cardDatabase.CARDTYPE])
	var cardHealth = str("",cardInfo[cardDatabase.CARDHEALTH])
	var cardCost = str("",cardInfo[cardDatabase.CARDCOST])
	var cardText = str("",cardInfo[cardDatabase.CARDTEXT])
	$Zones/CardNameBox/TextBoxName/CenterContainer/Name.text = cardName
	$Zones/CardNameBox/TextBoxCost/CenterContainer/Cost.text = cardCost
	$Zones/CardStatBox/TextBoxType/CenterContainer/Type.text = cardType
	$Zones/CardStatBox/TextBoxHealth/CenterContainer/Health.text = cardHealth
	$Zones/CardStatBox/TextBoxAttack/CenterContainer/Attack.text = cardAttack
	$Zones/CardTextBox/TextBoxText/CenterContainer/Text.text = cardText
	#
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	pass
