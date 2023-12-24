extends Button

@export var cost: int
@export var worldNode: Node2D

enum type{FACTORY, ANVIL, SEWING, WALL, BALLISTA, MISSILE, MINIGUN}
@export var buildingType: type
# Called when the node enters the scene tree for the first time.
func _ready():
	disabled = true
	worldNode.cookies_changed.connect(enable_button)
	$Label.set_text("🍪" + str(cost))

func getName():
	return self.name
	

func enable_button(cookies):
	disabled = cookies < cost

