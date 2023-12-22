extends Button

@export var mobName:String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _get_camera_center():
	var vtrans = get_canvas_transform()
	var top_left = -vtrans.get_origin() / vtrans.get_scale()
	var vsize = get_viewport_rect().size
	return top_left + 0.5*vsize/vtrans.get_scale()

func _on_pressed():
	var spawnPos = _get_camera_center()
	var selectMob = load("res://Mobs/" + mobName + ".tscn")
	var mobInstance = selectMob.instantiate()
	mobInstance.position = spawnPos
	get_tree().root.add_child(mobInstance)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


