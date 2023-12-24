extends StaticBody2D


# Called when the node enters the scene tree for the first time.
var bullet = preload("res://Towers/blue_icicle.tscn")
var bullet_dmg = 5
var pathName
var currTargets = []
var curr
var in_range = false
@onready var shoot_timer:Timer = $Timer

func _physics_process(_delta):
	#print("in range: ",in_range)
	#print(is_instance_valid(curr))
	if is_instance_valid(curr):
		$minigun_shooting.look_at(curr.global_position)
		if shoot_timer.is_stopped():
			shoot_timer.start()
			
	#this is so that if there are more enemies in range shoot
	if !is_instance_valid(curr):
		currTargets = get_node("Tower").get_overlapping_bodies()
		var tempArray = []
		for i in currTargets:
			if i != self and i.is_in_group("enemy"):
				tempArray.append(i)
		if tempArray.size() != 0:
			curr = tempArray[0]

func _on_tower_body_entered(_body):
	var tempArray = []
	currTargets = get_node("Tower").get_overlapping_bodies()
	#this is to remove the tower from its area and to have it only
	#shoot at Mobs and nothing else
	for i in currTargets:
		if i != self and i.is_in_group("enemy"):
			tempArray.append(i)
	#this is due to at the beginning there are no mobs in range
	var currTarget = null
		
	for i in range(tempArray.size()):
			currTarget = tempArray[i]
	#print("temparray: ", tempArray)
	#currTarget = tempArray[0]
	#print("the target in ballista: ",currTarget)
	curr = currTarget
	#print("inrange; ",in_range)
	#print("this is the group",get_tree().get_nodes_in_group("enemy"))
	if shoot_timer.is_stopped():
		shoot()

func shoot():
	if curr != null:
		var Temp_bullet = bullet.instantiate()
		Temp_bullet.dmg = bullet_dmg
		Temp_bullet.target = curr
		await get_tree().process_frame
		get_node("Bullet_Container").add_child(Temp_bullet)
		Temp_bullet.global_position = $Aim.global_position
		
		
func _on_tower_body_exited(body):
	currTargets = get_node("Tower").get_overlapping_bodies()
	#print("out range; ",in_range)
	#print("current targets", currTargets)
	if curr == body:
		curr = null


func _on_timer_timeout():
	shoot()
