extends Control


var slideDistance = 97.0
var drawSpeed = slideDistance/10.0

var isOpen = false
var _opened_ancor = Vector2(position.x + slideDistance, position.y)
var _closed_ancor = position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (isOpen and snappedf(position.x, 1) != _opened_ancor.x):
		position += Vector2(drawSpeed, 0.0)
	elif(!isOpen and snappedf(position.x, 1) != _closed_ancor.x):
		position -= Vector2(drawSpeed, 0.0)
	

func _on_work_station_menu_pressed():
	isOpen = !isOpen
