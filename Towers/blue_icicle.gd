extends CharacterBody2D


var target
var speed = 50
var dmg
var curtarget
	
func _physics_process(delta):
	#print("damage: ", dmg)
	#print("target: ", target)
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
		queue_free()


func _on_timer_timeout():
	queue_free()
