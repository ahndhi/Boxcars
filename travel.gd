extends Control
var locations : Array = [1,3,5,7,9,11,13,15,17]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	draw_locations()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func draw_locations():
	for i in 17:
		var curLoc = get_node("TravelLocation" + str(i + 1))
		curLoc.visible = false
	for local in locations:
		var curLoc = get_node("TravelLocation" + str(local))
		curLoc.visible = true

#change location

#player choice

func travel_button_pressed(emitter):
	locations.erase(int(emitter.name.right(-14)))
	draw_locations()
