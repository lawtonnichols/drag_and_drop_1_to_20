extends Node

var cards = []
var slots = []
var current_number = 1
var restart_original_position_y
var animation_time_elapsed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	restart_original_position_y = $Restart.position.y
	
	new_game()
	

func new_game():
	$Fireworks.hide()
	
	# clean up whatever's there
	#for node in $Slots.get_children():
		#node.remove_child(node)
	#for node in $Cards.get_children():
		#node.remove_child(node)
	for node in cards:
		node.queue_free()
	for node in slots:
		node.queue_free()
	cards = []
	slots = []
	
	# make a bunch of slots and cards
	for i in range(1, 21):
		var slot = load("res://slot.tscn").instantiate()
		slot.set_number(i)
		slots.append(slot)
		
		var card = load("res://card.tscn").instantiate()
		card.set_label_text(str(i))
		card.set_correct_slot(slot)
		card.time_for_the_next_number.connect(_on_time_for_the_next_number)
		cards.append(card)
	
	for slot in slots:
		$Slots.add_child(slot)
	
	var card_indices = range(20)
	randomize()
	card_indices.shuffle() # random order for the cards
	for i in card_indices:
		$Cards.add_child(cards[i])
	
	current_number = 1
	cards[current_number - 1].is_current_num = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	animation_time_elapsed += delta
	$Fireworks.material.set_shader_parameter("animation_time_elapsed", animation_time_elapsed)

func _on_time_for_the_next_number():
	cards[current_number - 1].is_current_num = false
	if current_number < 20:
		current_number += 1
		cards[current_number - 1].is_current_num = true
	elif current_number == 20:
		await get_tree().create_timer(1.0).timeout
		animation_time_elapsed = 0
		$Fireworks.show()
		await get_tree().create_timer(15.0).timeout
		$Fireworks.hide()

var restart_timer

func _on_restart_mouse_entered():
	$Restart.position.y = restart_original_position_y + 2
	await get_tree().create_timer(0.25).timeout
	$Restart.position.y = restart_original_position_y


func _on_restart_button_down():
	$Restart.position.y = restart_original_position_y + 2


func _on_restart_button_up():
	$Restart.position.y = restart_original_position_y
	new_game()
