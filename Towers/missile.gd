extends CharacterBody2D

var target
var speed = 200
var dmg = 1
var exploding_area = []
@onready var curtarget
@onready var boom_timer = get_node("Timer")

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
		if boom_timer.is_stopped():
			boom_timer.start()
	
func _on_area_2d_body_entered(body):
	print("enemy body in entered: ", curtarget)
	#print("Enemy name1: ", str(curtarget.get_meta("Type")))
	print("this is the group",get_tree().get_nodes_in_group("enemy"))
	if is_instance_valid(body) and curtarget != null:
		#for meta
		# if "Enemy" in bocy.get_meta("Type")
		#for groups
		print("the name of touched",body.name)
		if body.is_in_group("enemy"):
			for i in exploding_area:
				if is_instance_valid(i):
					i.changeHP(dmg)
			var boom = get_node("AnimatedSprite2D")
			boom.play("exploding")
			if boom_timer.is_stopped():
				boom_timer.start()
			#queue_free()



func _on_explosion_area_body_entered(body):
	if body.is_in_group("enemy"):
		exploding_area.append(body)
	print("explode area: ",exploding_area)


func _on_timer_timeout():
	queue_free()
