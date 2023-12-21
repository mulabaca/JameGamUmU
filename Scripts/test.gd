extends Node2D

@export var buttonGroup: ButtonGroup
@export var AdjacentOnly: bool

var selectedTurretScene = preload("res://Prefabs/anvil.tscn") #replace with null
var tileMap = null
var placing = false
var settingPlacing = false
var hoverCell = null;

const AVAILABLE = Vector2i(9,0)
const UNAVAILABLE = Vector2i(10,0)



func _ready():
	# Assuming TileMap is a child of the main scene
	tileMap = $TileMap as Node2D
	print(buttonGroup.get_buttons())
	for b in buttonGroup.get_buttons():
		b.pressed.connect(button_pressed)
	
	hoverCell = get_hovered_cell(get_global_mouse_position())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if placing:
		var mouse_position = get_global_mouse_position()
		showOnCursor("unused", mouse_position)
		
		if (Input.is_action_pressed("placeTurret")):
			var grid_position = world_to_map(mouse_position)
			print(Vector2i(grid_position.x/32, grid_position.y/32))
			
			if (!is_position_occupied(grid_position, 2)):
				if AdjacentOnly:
					if (getAvailability(get_hovered_cell(mouse_position)) == AVAILABLE):
						place(grid_position)
				else:
					place(grid_position)
	
	#ignore the click that activated it
	elif Input.is_action_just_released("placeTurret") and settingPlacing:
		settingPlacing = false
		placing = true


func button_pressed():
	if !placing:
		settingPlacing = true
	else:
		placing = false;
		removeAvailability(hoverCell);
	
	
	#get turret from button here
	


# Check if a position is occupied
func is_position_occupied(tilePosition: Vector2i, layer: int) -> bool:
	var tile_index = tileMap.get_cell_source_id(layer, Vector2i(tilePosition.x/32, tilePosition.y/32))
	return tile_index != -1
#same as above, but with atlas coordinates
func is_cell_availiable(cell: Vector2i) -> bool:
	var tile_index = tileMap.get_cell_source_id(2, cell)
	print(cell)
	print(tile_index)
	
	return tile_index == -1
	
#place workstation or turret
func place(grid_position: Vector2i):
		placing = false
		buttonGroup.get_pressed_button().set_pressed_no_signal(false)
	#if cookies >= cost:
		var turret_instance = selectedTurretScene.instantiate() #instance() does nothing
		turret_instance.position = Vector2i(grid_position.x + 16 , grid_position.y + 16);
		add_child(turret_instance)

		# Set the cell in the TileMap to indicate that it's occupied by a turret
		removeAvailability(hoverCell)
		tileMap.set_cell(2, Vector2i(grid_position.x/32 , grid_position.y/32), 0, Vector2i(8,0), 0)
		
		# Deduct turret cost from player resources
		#playerResources -= turretCost

#get global coordinates that match the grid
func world_to_map(world_position: Vector2):
	return Vector2i(nearest32(world_position.x), nearest32(world_position.y))

func get_hovered_cell(mousePosition: Vector2):
	return Vector2i(nearest32(mousePosition.x)/32, nearest32(mousePosition.y)/32)
	
#get the closetst grid coordinste
func nearest32(n:int):
	var snappedN = snappedi(n, 32)
	if(snappedN > n):
		return snappedN-32
	return snappedN


#Will use to show turret while placing
func showOnCursor(turret: String, mousePosition: Vector2):
	var newHovercell = get_hovered_cell(mousePosition)
	if newHovercell != hoverCell:
		removeAvailability(hoverCell)
		hoverCell = newHovercell
		showAvailability(hoverCell)

func showAvailability(cell: Vector2i):
	var availability = getAvailability(cell)
	print(availability)
	tileMap.set_cell(3, cell, 0, availability, 0)
	
func removeAvailability(cell: Vector2i):
	tileMap.erase_cell(3, cell)
	
func getAvailability(cell: Vector2i):
	
	if !is_cell_availiable(cell):
		return UNAVAILABLE
	
	if AdjacentOnly:
		for c in tileMap.get_surrounding_cells(cell):
			if !is_cell_availiable(c):
				print(c)
				return AVAILABLE
		return UNAVAILABLE
	
	return AVAILABLE
