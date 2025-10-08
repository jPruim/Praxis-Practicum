extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(find_children("*"))
	for node in get_nodes_in_scene(get_tree().current_scene):
		print(node.name)
	pass # Replace with function body.


func get_nodes_in_scene(scene:Node) -> Array:
	var nodes = [scene]
	for child in scene.get_children():
		nodes.append_array(get_nodes_in_scene(child))
	
	return nodes

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
