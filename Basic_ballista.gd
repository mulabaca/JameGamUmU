extends StaticBody2D

var icicle = preload("res://Towers/blue_icicle.tscn")
var icicle_dmg = 5
var pathName
var currTargets = []
var curr


#this is the Tower connecting(signal) to the body which is the Basic_Ballista for entering
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
		#this is here as a place holder due to have not figure a way
		#to check which mob is the closest
		currTarget = tempArray[0].get_node("../")
		curr = currTarget
		look_at(curr.position)
		
		#this breaks because object is not a vector 
		var Temp_Icicle = icicle.instantiate()
		Temp_Icicle.dmg = icicle_dmg
		Temp_Icicle.target = curr
		get_node("Icicle_Container").add_child(Temp_Icicle)
		Temp_Icicle.global_position = $Aim.global_position
		print(tempArray)
		
		
#this is the Tower connecting(signal) to the body which is the Basic_Ballista for exiting
func _on_tower_body_exited(body):
	pass # Replace with function body.
