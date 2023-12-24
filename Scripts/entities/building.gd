extends Area2D

@export var health: int
@export var maxHealth: int
var bodiesInCollision:Array[Node2D] = []
@export var breakAnimationFrames: int
@export var resourceGain: int
@export var resouceCooldown: int
var working = true

@onready var timer:Timer = $Timer
var resourceTimer

enum ResourceType{NONE, COOKIES, METALTOYS, PLUSHIES}
@export var resource: ResourceType
signal gained_cookies(cookies:int)
signal gained_metal(metal:int)
signal gained_plush(plushies:int)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$HealthBar.set_max(maxHealth)
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
		rootNode.removeBuilding(self)
	elif breakAnimationFrames > 1:
		showDamage()

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

func showDamage():
	var frame = floori(breakAnimationFrames - health/maxHealth * breakAnimationFrames)
	$AnimatedSprite2D.set_frame(frame)


func _on_resource_timer_timeout():
	if working:
		match resource:
			ResourceType.COOKIES:
				gained_cookies.emit(resourceGain)
			ResourceType.METALTOYS:
				gained_metal.emit(resourceGain)
			ResourceType.PLUSHIES:
				gained_plush.emit(resourceGain)
		
		$Label.visible = true
		$ResourceTimer.start()
		$labelCooldown.start()
	

func _on_label_cooldown_timeout():
	$Label.visible = false
	
func stopWorking():
	working = false
	$AnimatedSprite2D.set_animation("Default")
	$AnimatedSprite2D.play()

func startWorking():
	working = true
	$ResourceTimer.start()
	$AnimatedSprite2D.set_animation("Working")
	$AnimatedSprite2D.play()
