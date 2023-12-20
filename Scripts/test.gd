extends Node2D

@export var buttonGroup: ButtonGroup

var selectedTurretScene = preload("res://Prefabs/anvil.tscn") #replace with null
var tileMap = null
var placing = false
var settingPlacing = false



func _ready():
	# Assuming TileMap is a child of the main scene
	tileMap = $TileMap as Node2D
	print(buttonGroup.get_buttons())
	for b in buttonGroup.get_buttons():
		b.pressed.connect(button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_pressed("placeTurret") and placing):
		var mouse_position = get_global_mouse_position()
		var grid_position = world_to_map(mouse_position)
		print(Vector2i(grid_position.x/32, grid_position.y/32))
		if (!is_position_occupied(grid_position, 2)):
			place(grid_position)
	#ignore the click that activated it
	elif Input.is_action_just_released("placeTurret") and settingPlacing:
		settingPlacing = false
		placing = true


func button_pressed():
	settingPlacing = true
	
	#get turret from button here
	


# Check if a position is occupied
func is_position_occupied(tilePosition: Vector2i, layer: int) -> bool:
	var tile_index = tileMap.get_cell_source_id(layer, Vector2i(tilePosition.x/32, tilePosition.y/32))
	print(tile_index)
	return tile_index != -1
	
#place workstation or turret
func place(grid_position: Vector2i):
		placing = false
		buttonGroup.get_pressed_button().set_pressed_no_signal(false)
	#if cookies >= cost:
		var turret_instance = selectedTurretScene.instantiate() #instance() does nothing
		turret_instance.position = Vector2i(grid_position.x + 16 , grid_position.y + 16);
		add_child(turret_instance)

		# Set the cell in the TileMap to indicate that it's occupied by a turret
		tileMap.set_cell(2, Vector2i(grid_position.x/32 , grid_position.y/32), 0, Vector2i(8,0), 0)

		# Deduct turret cost from player resources
		#playerResources -= turretCost

#get global coordinates that match the grid
func world_to_map(world_position):
	return Vector2i(nearest32(world_position.x), nearest32(world_position.y))
	
#get the closetst grid coordinste
func nearest32(n:int):
	var snappedN = snappedi(n, 32)
	if(snappedN > n):
		return snappedN-32
	return snappedN
	
#Will use to show turret while placing
func showOnCursor(turret: String):
	pass
	
