extends Node2D

@export var buttonGroup: ButtonGroup
@export var AdjacentOnly: bool
@export var dayLenght: int
@export var buildingArray: Array[Node2D] = []
@export var cookiesStored: int
@export var requiredMetalToys: int
@export var requiredPlushies: int

enum time{DAWN, MORNING, NOON, AFTERNOON, EVENING, MIDNIGHT}

var selectedTurretScene = preload("res://Prefabs/anvil.tscn") #replace with null
var tileMap = null
var placing = false
var settingPlacing = false
var hoverCell = null;
var dayTime = time.MORNING

#toys
var metalStored = 0
var plushStored = 0

const AVAILABLE = Vector2i(9,0)
const UNAVAILABLE = Vector2i(10,0)

signal cookies_changed(cookies)



func _ready():
	# Assuming TileMap is a child of the main scene
	tileMap = $TileMap as Node2D
	#print(buttonGroup.get_buttons())
	for b in buttonGroup.get_buttons():
		b.pressed.connect(button_pressed)
		
	
	hoverCell = get_hovered_cell(get_global_mouse_position())
	
	$TileMap/dayTimer.start(dayLenght/7.0)
	cookies_changed.emit(cookiesStored)
	$"Camera2D/Cookie counter".set_text("🍪" + str(cookiesStored))
	$"Camera2D/Metal counter".set_text("🤖0/"+str(requiredMetalToys))
	$"Camera2D/Plush counter".set_text("🧸0/"+str(requiredPlushies))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if placing:
		var mouse_position = get_global_mouse_position()
		showOnCursor("unused", mouse_position)
		
		if (Input.is_action_pressed("placeTurret")):
			var grid_position = world_to_map(mouse_position)
			#print(Vector2i(grid_position.x/32, grid_position.y/32))
			
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
	
	changeLight()


func button_pressed():
	if !placing:
		settingPlacing = true

	#get turret from button here
	var currButton : BaseButton = buttonGroup.get_pressed_button()
	if currButton != null:
		match currButton.buildingType:
			0:
				selectedTurretScene = load("res://Prefabs/factory.tscn")
			
			1:
				selectedTurretScene = load("res://Prefabs/anvil.tscn")
			
			2:
				selectedTurretScene = load("res://Prefabs/sewing_machine.tscn")
			
			3:
				selectedTurretScene = load("res://Prefabs/wall.tscn")
			
			4:
				selectedTurretScene = load("res://Towers/basic_ballista.tscn")
			
			5:
				selectedTurretScene = load("res://Towers/Tree_Missile.tscn")
	else:
		placing = false;
		removeAvailability(hoverCell);



# Check if a position is occupied
func is_position_occupied(tilePosition: Vector2i, layer: int) -> bool:
	var tile_index = tileMap.get_cell_source_id(layer, Vector2i(tilePosition.x/32, tilePosition.y/32))
	return tile_index != -1
#same as above, but with atlas coordinates
func is_cell_availiable(cell: Vector2i) -> bool:
	var tile_index = tileMap.get_cell_source_id(2, cell)
	#print(cell)
	#print(tile_index)
	
	return tile_index == -1
	
#place workstation or turret
func place(grid_position: Vector2i):
		placing = false
		var pressed =  buttonGroup.get_pressed_button()
		pay_cookies(pressed.cost)
		pressed.set_pressed_no_signal(false)
		
		var turret_instance = selectedTurretScene.instantiate() #instance() does nothing
		turret_instance.position = Vector2i(grid_position.x + 16 , grid_position.y + 16);
		add_child(turret_instance)
		buildingArray.append(turret_instance)
		print("Building Array", buildingArray)
		if turret_instance.is_in_group("resourceBuilding"):
			match turret_instance.resource:
				1:
					turret_instance.gained_cookies.connect(gained_cookies)
				2:
					turret_instance.gained_metal.connect(gained_metal)
				3:
					turret_instance.gained_plush.connect(gained_plush)
			
			if dayTime < time.EVENING or dayTime == time.DAWN:
				turret_instance.startWorking()
			else:
				turret_instance.stopWorking()
		# Set the cell in the TileMap to indicate that it's occupied by a turret
		removeAvailability(hoverCell)
		tileMap.set_cell(2, Vector2i(grid_position.x/32 , grid_position.y/32), 0, Vector2i(8,0), 0)
		
		# Deduct turret cost from player resources
		#playerResources -= turretCost

func removeBuilding(body):
	for i in range(buildingArray.size()-1, -1, -1):
			if buildingArray[i] == body:
				buildingArray.remove_at(i)
	tileMap.set_cell(0, get_hovered_cell(body.global_position), 0, Vector2i(8,0), 0)
	tileMap.erase_cell(2, get_hovered_cell(body.global_position))
	body.queue_free()
	
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
	#print(availability)
	tileMap.set_cell(3, cell, 0, availability, 0)
	
func removeAvailability(cell: Vector2i):
	tileMap.erase_cell(3, cell)
	
func getAvailability(cell: Vector2i):
	
	if !is_cell_availiable(cell):
		return UNAVAILABLE
	
	if AdjacentOnly:
		for c in tileMap.get_surrounding_cells(cell):
			if !is_cell_availiable(c):
				return AVAILABLE
		return UNAVAILABLE
	
	return AVAILABLE



func _on_day_timer_timeout():
	
	match dayTime:
		time.DAWN:
			dayTime = time.MORNING
		time.MIDNIGHT:
			dayTime = time.DAWN
			$Camera2D/TimeIndicator.set_day()
			for building in get_tree().get_nodes_in_group("resourceBuilding"):
				building.startWorking()
		time.EVENING:
			dayTime = time.MIDNIGHT
		time.AFTERNOON:
			dayTime = time.EVENING
			$Camera2D/TimeIndicator.set_night()
			for building in get_tree().get_nodes_in_group("resourceBuilding"):
				building.stopWorking()
		time.NOON:
			dayTime = time.AFTERNOON
		time.MORNING:
			dayTime = time.NOON
	
	$TileMap/dayTimer.start(dayLenght/7.0)

func changeLight():
	var t = $TileMap/dayTimer.get_time_left()/(dayLenght/7.0)
	var newLight = Color(1.0, 1.0, 1.0)
	match dayTime:
		time.DAWN:
			const B = Color(0.8,0.8,0.8) #DAWN
			const A = Color(1.0,0.95,0.9) #Morning
			newLight = B*t + A*(1.0-t)	
		
		time.MIDNIGHT:
			const B = Color(0.4,0.4,0.4) #Midnight
			const A = Color(0.8,0.8,0.8) #Dawn
			newLight = B*t + A*(1.0-t)
		
		time.EVENING:
			newLight = Color(0.4,0.4,0.4)
		
		time.AFTERNOON:
			const B = Color(1.0,0.68,0.5) #Afternoon
			const A = Color(0.4,0.4,0.4) #Evening
			newLight = B*t + A*(1.0-t)
		time.NOON:
			const B = Color(1.0,1.0,1.0) #Noon
			const A = Color(1.0,0.68,0.5) #Afternoon
			newLight = B*t + A*(1.0-t)
		time.MORNING:
			const B = Color(1.0,0.95,0.9) #Morning
			const A = Color(1.0,1.0,1.0) #Noon
			newLight = B*t + A*(1.0-t)
	
	tileMap.set_layer_modulate(0, newLight)
	tileMap.set_layer_modulate(1, newLight)
	tileMap.set_layer_modulate(2, newLight)

func gained_cookies(cookies):
	cookiesStored += cookies;
	$"Camera2D/Cookie counter".set_text("🍪" + str(cookiesStored))
	cookies_changed.emit(cookiesStored)

#returns bool for weather it successfully paid cookies
func pay_cookies(cost: int) -> bool:
	if cookiesStored >= cost:
		cookiesStored -= cost
		$"Camera2D/Cookie counter".set_text("🍪" + str(cookiesStored))
		cookies_changed.emit(cookiesStored)
		return true
	return false

func gained_metal(metal: int):
	metalStored += metal;
	$"Camera2D/Metal counter".set_text("🤖"+str(metalStored)+"/"+str(requiredMetalToys))

func gained_plush(plush: int):
	plushStored += plush
	$"Camera2D/Plush counter".set_text("🧸"+str(plushStored)+"/"+str(requiredPlushies))
