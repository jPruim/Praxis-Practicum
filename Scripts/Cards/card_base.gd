class_name CardBase
extends Node2D

# Properties
var card_data:CardData = null
var hand_position: Vector2
var in_slot: bool  = false # Boolean for being in the card_slot
var ai_card: bool = false
var being_cast: bool = false
var being_hovered: bool = false
var default_tag_location = Vector2(-176, 0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_default_data()
	get_parent().connect_card_signals(self)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# Set to full deep copy of the passed in CardBase
func copy(card: CardBase):	
	card_data = card.card_data.duplicate(true)
	hand_position = card.hand_position
	in_slot = card.in_slot
	ai_card = card.ai_card
	being_cast = card.being_cast

func set_default_data():
	if(card_data):
		return
	card_data = CardData.new()

func _on_area_2d_mouse_entered() -> void:
	SignalBus.emit_signal("card_hovered", self)
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	SignalBus.emit_signal("card_hovered_off", self)
	pass # Replace with function body.


# Set Card from a CardData object
func set_all(data: CardData):
	card_data = data

# Set Display and CardData from a CardData object
func set_display(data: CardData):
	set_display_name(data.display_name)
	$CardFront/Attack.text = str(data.summon_attack)
	$CardFront/Health.text = str(data.summon_health)
	$CardFront/Details.text = data.card_text
	$CardFront/Cost.text = str(data.cast_time)
	$CardFront/Type.text = data.card_type
	$CardFront/DirectDamage.text = str(data.direct_damage)
	$CardFront/DamageType.text = data.damage_type
	$CardFront/DirectBlock.text = str(data.direct_block)
	$TagList.set_taglist(data.tags)
	# Handle Animations not being added yet ( So I can add them over time)
	if data.animation != "":
		set_animation(data.animation)
	else:
		set_animation()
	
# Create Array from Card
func get_card_info():
	return card_data

func get_card_type():
	return card_data.card_type

func set_animation(animation: String = "FireSparks"):
	$CardFront/Container/AnimatedSprite2D.animation = animation # TODO: make an empty spriteframe at some point
	
func set_display_name(name: String):
	card_data.display_name = name
	$CardFront/Name.text = name

func set_health(hp: int):
	card_data.summon_health = hp
	$CardFront/Health.text = str(hp)
	
func adjust_health(hp: int):
	set_health(card_data.summon_health + hp)

# Flip card to front from back
func animation_reveal():
	# Check if card back is visible
	if $CardFront.z_index < $CardBack.z_index:
		$AnimationPlayer.play("card_flip")

# Flip card to back	
func animation_conceal():
	# Check if Card front is visible
	if $CardFront.z_index > $CardBack.z_index:
		$AnimationPlayer.play_backwards("card_flip")
	
# Animate card to position
func animate_card_to_position(position, speed = Globals.DEFAULT_ASPEED):
	var tween = get_tree().create_tween()
	tween.tween_property($".", "position", position, speed)
	
# Animate card to Scale
func animate_card_to_scale(scale, speed = Globals.DEFAULT_ASPEED):
	var tween = get_tree().create_tween()
	tween.tween_property($".", "scale", scale, speed)


func animate_card_to_slot(slot: CardSlot, scale = Globals.CARD_SCALE_PlACED, speed = Globals.DEFAULT_ASPEED):
	animate_card_to_position(slot.position, speed)
	animate_card_to_scale(scale, speed)



# Change card affects TODO: Decide if cards in cardslots need animations (go and add a new mask for animations, and separate from card detection)
func card_affects(hovered: bool):
	var animation_sprite = get_node("CardFront/Container/AnimatedSprite2D")
	being_hovered = hovered
	if being_hovered:
		$".".scale = Vector2(1.05, 1.05)
		$".".z_index = Globals.Z_INDEX["card_hovered"]
		# Play Animation
		animation_sprite.play()
		
		# If card is in play or being cast or owned by the player
		if(in_slot || being_cast || !ai_card):
			$TagList.visible = true
			$TagList.global_position.x = clamp($TagList.global_position.x, 0 + $TagList.size.x/2, 
				Globals.VIEWPORT_SIZE.x -  $TagList.size.x/2)
			$TagList.global_position.y = clamp($TagList.global_position.y, 0 + $TagList.size.y/2, 
				Globals.VIEWPORT_SIZE.y -  $TagList.size.y/2)
		
	else:
		$TagList.visible = false
		$TagList.position = default_tag_location
		if $"." is CasterFrameBase:
			$".".scale = Globals.CARD_SCALE_PlACED
			$".".z_index = Globals.Z_INDEX["caster_frame"]
		elif $".".being_cast:	
			if $".".ai_card:
				$".".z_index = Globals.Z_INDEX["card_cast_enemy"]
			else:
				$".".z_index = Globals.Z_INDEX["card_cast_player"]
			$".".scale = Globals.CAST_SCALE
		elif !$".".in_slot:
			$".".scale  = Vector2( 1, 1)
			$".".z_index = Globals.Z_INDEX["card"]
		else:
			$".".scale = Globals.CARD_SCALE_PlACED
			$".".z_index = Globals.Z_INDEX["card_in_slot"]
		# Pause Animation
		animation_sprite.pause()
