extends Area2D
signal loose_toys
# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout(): 
	if !get_overlapping_bodies().is_empty():
		loose_toys.emit()
	$Timer.start()

