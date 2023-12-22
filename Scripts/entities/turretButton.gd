extends Button

@export var cost: int
@export var worldNode: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	disabled = true
	worldNode.coockies_changed.connect(enable_button)
	$Label.set_text("🍪" + str(cost))

func getName():
	return self.name
	

func enable_button(coockies):
	disabled = coockies < cost

