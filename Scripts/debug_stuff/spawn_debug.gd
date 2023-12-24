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

func spawn_enemy(mob_name:String, spawn_pos:Vector2):
	var selectMob = load("res://Mobs/" + mob_name + ".tscn")
	var mobInstance = selectMob.instantiate()
	mobInstance.position = spawn_pos
	print(get_tree().get_root().get_node("World/enemies").name)
	get_tree().get_root().get_node("World/enemies/").add_child(mobInstance)
	#get_tree().root.add_child(mobInstance)

func _on_pressed():
	var spawnPos = _get_camera_center()
	spawn_enemy(mobName, spawnPos)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


