extends Area2D

var health: int
@export var maxHealth: int
var bodiesInCollision:Array[Node2D] = []

@onready var timer:Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	
	$HealthBar.set_max(maxHealth)
	health = maxHealth
	$HealthBar.value = health
	$HealthBar.visible = false

func damage():
	$HealthBar.visible = true
	for body in bodiesInCollision:
		if body.has_meta("damage"):
			health = health - body.get_meta("damage")
		else:
			print(body, " has no damage!")
	$HealthBar.value = health
	
	if health <= 0:
		var rootNode = get_tree().get_root().get_node("World")
		rootNode.removeBuilding(get_parent())


func _on_body_entered(body):
	if body.is_in_group("enemy") == true:
		bodiesInCollision.append(body)
		if timer.is_stopped():
			timer.start(0.5)

func _on_body_exited(body):
	if body.is_in_group("enemy") == true:
		for i in range(bodiesInCollision.size()-1, -1, -1):
			if bodiesInCollision[i] == body:
				bodiesInCollision.remove_at(i)

func _on_timer_timeout():
	if bodiesInCollision.is_empty():
		timer.stop()
	else:
		damage()
