extends Control

func _ready():
	#initialize(false)
	# we don't want to use this here, need to load this scene
	pass

func initialize(isWinning:bool):
		$music.play(4.9)
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _on_re_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/test.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")
