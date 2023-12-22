extends CharacterBody2D


var target
var speed = 100
var dmg

func _physics_process(delta):
	target = get_parent().get_parent().get_parent().get_node("Test_Mob")
	velocity = global_position.direction_to(target.position) * speed
	look_at(target.position)
	move_and_slide()


func _on_area_2d_body_entered(body):
	if "Test_Mob" in body.name:
		queue_free()
