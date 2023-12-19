extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	region_rect.position.x -= delta*5
	#region_rect.position.y -= delta*5
	while region_rect.position.x < 0:
		region_rect.position.x += 64
	#while region_rect.position.y < 0:
		#region_rect.position.y += 64
