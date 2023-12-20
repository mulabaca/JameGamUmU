extends Camera2D
var anchor = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("move"):
		anchor = get_global_mouse_position()
	elif Input.is_action_just_released("move"):
		anchor = null
	
	if Input.is_action_just_pressed("zoomIn"):
		scale *= 1/1.1
		zoom *= 1.1
	elif Input.is_action_just_pressed("zoomOut"):
		scale *= 1.1
		zoom *= 1/1.1
	
	if anchor != null:
		var mouse_position = get_global_mouse_position()
		position += anchor - mouse_position
