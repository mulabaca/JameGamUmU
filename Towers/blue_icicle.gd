extends CharacterBody2D


var target
var speed = 200
var dmg = 5
var curtarget
	
func _physics_process(delta):
	#print("damage: ", dmg)
	#print("target: ", target)
	#this deals with enemy types so having multiple of one type of mob on the screen 
	#causes problems due to they are all the same type and the world enemy target
	#is one gobbo while spawning in multiple gobbos causes it to not know which to choose
	#get_nodes_in_group
	curtarget = get_tree().get_root().get_node(str("World/enemies/",target))
	velocity = global_position.direction_to(curtarget.position) * speed
	look_at(curtarget.position)
	move_and_slide()

#the body for this is the icicle itsself
func _on_area_2d_body_entered(body):
	print("enemy body: ", body)
	print("Enemy name1: ", str(body.get_meta("Type")))
	if "Enemy" in str(body.get_meta("Type")):
		print("Enemy name: ", str(body.get_meta("Type")))
		body.changeHP(dmg)
		queue_free()


func _on_timer_timeout():
	queue_free()
