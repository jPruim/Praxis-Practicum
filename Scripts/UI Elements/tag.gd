class_name Tag
extends MarginContainer


var tag_data = {
	"default": "Empty Tag",
	"fire": "Removes Ice, does double dmg to enemies with Fire",
	"ice": "Removes Fire, does double dmg to enemies with Ice",
	"strength": "Increase dmg by 1",
	"repeated": "Casts or attacks an additional time",
	"unstackable": "Summon cannot stack",
	"barrier": "Blocks dmg, Decays if not used",
	"delayed": "Adds 1 cast time",
	"summon": "Attacks each turn",
}
var displaying: String = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func set_tag_data(tag_name: String):
	displaying = tag_name
	$VBoxContainer/MarginHeader/MarginContainer/Header.text = displaying
	if tag_data.has(tag_name):
		$VBoxContainer/MarginBody/MarginContainer/Label.text = tag_data[tag_name]
	$VBoxContainer/MarginBody/MarginContainer/Label.text = tag_data["default"]
	
