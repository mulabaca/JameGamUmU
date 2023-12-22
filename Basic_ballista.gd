extends StaticBody2D

var icicle = preload("res://Towers/blue_icicle.tscn")
var icicle_dmg = 5
var pathName
var currTargets = []
var curr
var in_range = false
@onready var shoot_timer = get_node("Timer")

func _physics_process(delta):
	#print("in range: ",in_range)
	#print(is_instance_valid(curr))
	if is_instance_valid(curr):
		look_at(curr.global_position)
		if shoot_timer.is_stopped():
			shoot_timer.start()
		
		
#this is the Tower connecting(signal) to the body which is the Basic_Ballista for entering
#this checks once when something enters
func _on_tower_body_entered(body):
	#test_Mob is the node in test.gd for spawning mob
	if "Test_Mob" in body.name:
		var tempArray = []
		currTargets = get_node("Tower").get_overlapping_bodies()
		#this is to remove the tower from its area and to have it only
		#shoot at Mobs and nothing else
		for i in currTargets:
			if "Mob" in i.name:
				tempArray.append(i)
		#this is due to at the beginning there are no mobs in range
		var currTarget = null
		
		for i in range(tempArray.size()):
				currTarget = tempArray[i]
		#print("temparray: ", tempArray)
		#currTarget = tempArray[0]
		#print("the target in ballista: ",currTarget)
		curr = currTarget
		print("inrange; ",in_range)
		shoot()
		
		
func shoot():
	var Temp_Icicle = icicle.instantiate()
	Temp_Icicle.dmg = icicle_dmg
	Temp_Icicle.target = curr
	get_node("Icicle_Container").add_child(Temp_Icicle)
	Temp_Icicle.global_position = $Aim.global_position
		
#this is the Tower connecting(signal) to the body which is the Basic_Ballista for exiting
#this checks every second if something has exited
func _on_tower_body_exited(body):
	currTargets = get_node("Tower").get_overlapping_bodies()
	print("out range; ",in_range)
	print("current targets", currTargets)
	if curr == body:
		curr = null
	print("curr: ", curr)

func _on_timer_timeout():
	shoot()
