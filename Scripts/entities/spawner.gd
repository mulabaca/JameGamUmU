extends StaticBody2D

@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D
var current_world
var spawn_location

# Called when the node enters the scene tree for the first time.
func _ready():
	current_world = get_tree().get_root().get_node_or_null("World")
	if current_world == null:
		print("Spawner can't find 'World' node! Freeing...")
		queue_free()
	spawn_location = self.global_position + pick_direction()

func spawn_enemy(mob_name:String, spawn_pos:Vector2):
	var selectMob = load("res://Mobs/" + mob_name + ".tscn")
	var mobInstance = selectMob.instantiate()
	mobInstance.position = spawn_pos
	get_tree().get_root().get_node("World/enemies/").add_child(mobInstance)
	#get_tree().root.add_child(mobInstance)

func pick_direction():
	var vector:Vector2
	if self.global_position.y < 0 and abs(self.global_position.y) >= abs(self.global_position.x): 
		sprite.frame = 1				# left
		vector = Vector2(0.0,0.5)
	elif self.global_position.y >= 0 and abs(self.global_position.y) <= abs(self.global_position.x): 
		sprite.frame = 2				# right
		vector = Vector2(0.0,-0.5)
	elif self.global_position.x >= 0: 	# top
		sprite.frame = 0
		vector = Vector2(-0.5,0.0)
	else: 								# bottom
		sprite.frame = 3
		vector = Vector2(0.5,0.0)
		
	return vector


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if current_world.dayTime > current_world.time.AFTERNOON and $Spawn_Timer.is_stopped():
		$Spawn_Timer.start()


func _on_spawn_timer_timeout():
	if current_world.dayTime < current_world.time.EVENING:
		$Spawn_Timer.stop()
		
	# change to get enemy from a list rather than call directly here
	spawn_enemy("gobbo", spawn_location)
