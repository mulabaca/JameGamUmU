extends Control


var slideDistance = 97.0
var drawSpeed = slideDistance/10.0

var isOpen = false
var _opened_ancor = null
var _closed_ancor = null

# Called when the node enters the scene tree for the first time.
func _ready():
	_opened_ancor = Vector2($WorkStationMenu.position.x + slideDistance, $WorkStationMenu.position.y)
	_closed_ancor = $WorkStationMenu.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (isOpen and snappedf($WorkStationMenu.position.x, 1) != _opened_ancor.x):
		$WorkStationMenu.position += Vector2(drawSpeed, 0.0)
	elif(!isOpen and snappedf($WorkStationMenu.position.x, 1) != _closed_ancor.x):
		$WorkStationMenu.position -= Vector2(drawSpeed, 0.0)
	

func _on_work_station_menu_pressed():
	isOpen = !isOpen
