extends CharacterBody2D


var target
var speed = 200
var dmg = 5
@onready var curtarget
	
func _physics_process(_delta):
	#print("damage: ", dmg)
	#print("target: ", target)
	#this deals with enemy types so having multiple of one type of mob on the screen 
	#causes problems due to they are all the same type and the world enemy target
	#is one gobbo while spawning in multiple gobbos causes it to not know which to choose
	#get_nodes_in_group
	#curtarget = get_tree().get_root().get_node(str("World/enemies/",target))
	if target != null:
		curtarget = target
		velocity = global_position.direction_to(curtarget.position) * speed
		look_at(curtarget.position)
		move_and_slide()
	else:
		queue_free()

#the body for this is the icicle itsself
func _on_area_2d_body_entered(body):
	#print("enemy body in entered: ", curtarget)
	#print("Enemy name1: ", str(curtarget.get_meta("Type")))
	#print("this is the group",get_tree().get_nodes_in_group("enemy"))
	if is_instance_valid(body) and curtarget != null:
		#for meta
		# if "Enemy" in bocy.get_meta("Type")
		#for groups
		if body.is_in_group("enemy"):
			body.changeHP(dmg)
			queue_free()

func gone():
	var R = curtarget.instance()
	get_parent().call_deffered("add_child", R)
	
func _on_timer_timeout():
	queue_free()
