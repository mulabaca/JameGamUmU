extends CharacterBody2D

@export var maxHealth:int
var health:int

const movement_speed: float = 20.0
var movement_target_position: Vector2 = Vector2(0,0)
var rng:RandomNumberGenerator = RandomNumberGenerator.new()

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	# HP
	health = maxHealth
	$HealthBar.set_max(maxHealth)
	$HealthBar.value = maxHealth
	$HealthBar.visible = false # hide HP until takes damage
	
	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func find_nearest_building(buildingArray, currentPos):
	var closest = null
	var closest_distance = 0.0
	for i in buildingArray:
		var current_distance = currentPos.distance_to(i.global_position)
		if closest == null or current_distance < closest_distance:
			closest = i
			closest_distance = current_distance
	#print("Closest building ", closest)
	return closest

func set_next_target():
	var rootNode = get_tree().get_root().get_node("World")
	var closestBuilding = find_nearest_building(rootNode.buildingArray, global_position)
	if closestBuilding == null:
		var randX = rng.randi_range(1, 3)
		var randY = rng.randi_range(1, 3)
		set_movement_target(Vector2(randX, randY))
	elif movement_target_position != closestBuilding.global_position:
		#print("Setting target")
		set_movement_target(closestBuilding.global_position)
		movement_target_position = closestBuilding.global_position

func _physics_process(_delta):
	if navigation_agent.is_navigation_finished():
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()

# Can heal or do damage to enemy here
func changeHP(damage):
	# negative damage values should heal enemy
	health = health - damage
	
	# handle healing to full, dying
	if health <=0:
		self.queue_free() # queue for safe deletion
		return # no need to contine
	
	elif health >= maxHealth: # heal to full
		health = maxHealth
		await get_tree().create_timer(2).timeout
		$HealthBar.visible = false
	
	$HealthBar.visible = true
	$HealthBar.value = health
	

func _on_timer_timeout():
	set_next_target()
