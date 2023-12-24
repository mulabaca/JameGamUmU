extends Node2D

var day:int = 13
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func add_day():
	day += 1
	$Label.set_text(str(day))

func get_day():
	return day
