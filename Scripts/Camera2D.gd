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
		var distance = anchor - mouse_position
		if(distance.length()*(1/(scale.x * delta)) > 6000):
			position_smoothing_enabled = true
			$Timer.start()
		position += anchor - mouse_position
	$Menu.global_position = global_position
		


func _on_timer_timeout():
	position_smoothing_enabled = false
