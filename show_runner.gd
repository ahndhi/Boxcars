extends Node
var allTheDice : Array = [
	[1,2,3,4,5,6],
	[1,2,3,4,5,6],
	[1,2,3,4,5,6],
	[1,2,3,4,5,6],
	[1,2,3,4,5,6],
	[1,2,3,4,5,6]	
]

var allTheWeights : Array = [
	PackedFloat32Array([1,1,1,1,1,1]),
	PackedFloat32Array([1,1,1,1,1,1]),
	PackedFloat32Array([1,1,1,1,1,1]),
	PackedFloat32Array([1,1,1,1,1,1]),
	PackedFloat32Array([1,1,1,1,1,1]),
	PackedFloat32Array([1,1,1,1,1,1])
]

var allTheColors : Array = [
	Color(0.827, 0.165, 0.004, 1.0),
	Color(0.827, 0.165, 0.004, 1.0),
	Color(0.613, 0.111, 0.002, 1.0),
	Color(0.613, 0.111, 0.002, 1.0),
	Color(0.399, 0.058, 0.001, 1.0),
	Color(0.399, 0.058, 0.001, 1.0)
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"main-slotstyle".prepare_dice(allTheDice,allTheWeights,allTheColors)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_mainslotstyle_request_dice() -> void:
	$"main-slotstyle".prepare_dice(allTheDice,allTheWeights,allTheColors)


func start_a_new_game():
	$FarkleMenu.visible = false
	$"main-slotstyle".score = 0
	$"main-slotstyle/Label2".text = str($"main-slotstyle".score)
	$"main-slotstyle".prepare_dice(allTheDice,allTheWeights,allTheColors)
	$"main-slotstyle/AddButton".disabled = true
	$"main-slotstyle/BankButton".disabled = true
	$"main-slotstyle/RollButton".disabled = false
	get_tree().paused = false


func _on_farkle_menu_quit_game() -> void:
	get_tree().quit()


func _on_mainslotstyle_farkled() -> void:
	$FarkleMenu.visible = true
