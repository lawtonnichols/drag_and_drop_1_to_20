extends Panel

signal time_for_the_next_number

var selected = false
var can_let_go = false
var locked = false
var start_point = null
var correct_slot
var is_current_num = false
var emitted = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_current_num:
		correct_slot.get_node("Highlighted").show()
	else:
		correct_slot.get_node("Highlighted").hide()
	
	if locked:
		correct_slot.get_node("Completed").show()
	else:
		correct_slot.get_node("Completed").hide()
	
func _physics_process(delta):
	if selected:
		global_position = lerp(global_position, get_global_mouse_position() - 0.5 * get_size(), 25 * delta)
		
		# see if we're over the correct slot
		if correct_slot.get_global_rect().has_point(get_global_mouse_position()) and is_current_num:
			can_let_go = true
		else:
			can_let_go = false
	elif can_let_go:
		var final_position = correct_slot.get_global_position() + get_global_rect().size / 16 + Vector2(0, 4)
		global_position = lerp(global_position, final_position, 25 * delta)
		locked = true
		if not emitted:
			time_for_the_next_number.emit()
			emitted = true
	elif start_point != null:
		global_position = lerp(global_position, start_point, 7 * delta)

#func _on_input_event(viewport, event, shape_idx):
	#if Input.is_action_just_pressed("click"):
		#selected = true
		#start_point = global_position

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and not locked:
				selected = true
				z_index = 999
				start_point = global_position
			else:
				selected = false
				z_index = 1
			

func set_label_text(s):
	$Label.text = s

func set_correct_slot(s):
	correct_slot = s
