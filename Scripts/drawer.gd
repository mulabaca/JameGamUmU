extends Control


var slideDistance = 97.0
var drawSpeed = slideDistance/10.0

var isOpen = false
var _opened_ancor = null
var _closed_ancor = null

@export var OtherMenu: Control

# Called when the node enters the scene tree for the first time.
func _ready():
	_opened_ancor = Vector2($ButtonMenu.position.x + slideDistance, $ButtonMenu.position.y)
	_closed_ancor = $ButtonMenu.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (isOpen and snappedf($ButtonMenu.position.x, 1) != _opened_ancor.x):
		$ButtonMenu.position += Vector2(drawSpeed, 0.0)
		if OtherMenu.isOpen:
			OtherMenu.isOpen = false
	elif(!isOpen and snappedf($ButtonMenu.position.x, 1) != _closed_ancor.x):
		$ButtonMenu.position -= Vector2(drawSpeed, 0.0)
	

func _on_work_station_menu_pressed():
	isOpen = !isOpen
