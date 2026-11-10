extends Node
var dummy = 0

var  TheDice : Array = [
	[1,1,1,1,1,1],
	[1,1,1,1,1,1],
	[1,1,1,1,1,1],
	[1,1,1,1,1,1],
	[1,1,1,1,1,1],
	[1,1,1,1,1,1]	
]

var TheWeights : Array = [
	PackedFloat32Array([1.0,1.0,1.0,1.0,1.0,1.0]),
	PackedFloat32Array([1.0,1.0,1.0,1.0,1.0,1.0]),
	PackedFloat32Array([1.0,1.0,1.0,1.0,1.0,1.0]),
	PackedFloat32Array([1.0,1.0,1.0,1.0,1.0,1.0]),
	PackedFloat32Array([1.0,1.0,1.0,1.0,1.0,1.0]),
	PackedFloat32Array([1.0,1.0,1.0,1.0,1.0,1.0])
]

var TheColors : Array = [
	Color(0.827, 0.165, 0.004, 1.0),
	Color(0.827, 0.165, 0.004, 1.0),
	Color(0.613, 0.111, 0.002, 1.0),
	Color(0.613, 0.111, 0.002, 1.0),
	Color(0.399, 0.058, 0.001, 1.0),
	Color(0.399, 0.058, 0.001, 1.0)
]

var allTheDice : Array = TheDice.duplicate(true)
var allTheWeights : Array = TheWeights.duplicate(true)
var allTheColors : Array = TheColors.duplicate(true)


var trueScore : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"main-slotstyle".prepare_dice(allTheDice,allTheWeights,allTheColors)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func _on_mainslotstyle_request_dice() -> void:
	$"main-slotstyle".prepare_dice(allTheDice,allTheWeights,allTheColors)


func start_a_new_game(fresh : bool = false):
	if fresh == true:
		allTheDice = TheDice.duplicate(true)
		allTheWeights = TheWeights.duplicate(true)
		allTheColors = TheColors.duplicate(true)
		trueScore = 0
	$FarkleMenu.visible = false
	$"main-slotstyle".score = 0
	$"main-slotstyle".totalScore = 0
	$"main-slotstyle".rolls = 3
	$"main-slotstyle/Label2".text = str($"main-slotstyle".score)
	$"main-slotstyle/TotalLabel".text = str($"main-slotstyle".totalScore)
	$"main-slotstyle/RollsLabel".text = str($"main-slotstyle".rolls)
	$"main-slotstyle".prepare_dice(allTheDice,allTheWeights,allTheColors)
	$"main-slotstyle/AddButton".disabled = true
	$"main-slotstyle/BankButton".disabled = true
	$"main-slotstyle/RollButton".disabled = false
	get_tree().paused = false


func _on_farkle_menu_quit_game() -> void:
	get_tree().quit()


func _on_mainslotstyle_farkled() -> void:
	$FarkleMenu.visible = true


func _on_win_menu_win_continue() -> void:
	$WinMenu.visible = false
	$store.visible = true
	$store.prepare_store(allTheDice,allTheWeights,allTheColors,trueScore)


func _on_mainslotstyle_win_round(score, winScore) -> void:
	$WinMenu.visible = true
	$WinMenu/Label.text = str(score) + "/" + str(winScore)
	$WinMenu/Label2.text = str(score) + "-" + str(winScore) + "=" + str(score - winScore) + "\n" + str(trueScore) + "+" + str(score - winScore) + "=" + str(trueScore + (score - winScore))
	trueScore += (score - winScore)


func _on_store_store_continue() -> void:
	$store.visible = false
	start_a_new_game()


func _on_store_item_bought(value) -> void:
	trueScore = value
	#if move.has("ad")
