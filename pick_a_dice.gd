extends Control
var diceScn = preload("res://dice-slotstyle.tscn")
var curMove : Dictionary = {}
var curChooseable : bool = false
var curDice : Node = null
var activeDice : Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#pass

func prepare_pick_a_dice(diceValues : Array, diceWeights : Array, diceColors : Array, chooseFace : bool, move : Dictionary):
	var dicePos
	curChooseable = chooseFace
	curMove = move
	if chooseFace == true:
		dicePos = Vector2(58,100)
	if chooseFace == false:
		dicePos = Vector2(58,440)
	for i in 6:
		var diceInst = diceScn.instantiate()
		diceInst.faces = diceValues[i]
		diceInst.weights = diceWeights[i]
		diceInst.color = diceColors[i]
		diceInst.position = dicePos
		diceInst.change_number(diceInst.faces.pick_random())
		diceInst.movable = false
		diceInst.connect("mouseIn",dice_entered)
		diceInst.connect("mouseOut",dice_exited)
		diceInst.connect("picked", dice_selected)
		activeDice.append(diceInst)
		add_child(diceInst)
		dicePos.x += 72


func dice_entered(emitter):
	var diceStats : String = ""
	var diceStats2 : String = ""
	for i in 3:
		diceStats += str(emitter.faces[i]) + " / " + str(emitter.weights[i] * 100) + "%\n"
	for i in range(3,6):
		diceStats2 += str(emitter.faces[i]) + " / " + str(emitter.weights[i] * 100) + "%\n"
	$StatsLabel.text = diceStats
	$StatsLabel2.text = diceStats2


func dice_exited():
	$StatsLabel.text = ""
	$StatsLabel2.text = ""


func dice_selected(emitter):
	var selectedDice = emitter.owner
	if curChooseable == true:
		for dice in activeDice:
			dice.select_hilight_off()
		emitter.select_hilight_on()
	else:
		for dice in activeDice:
			dice.select_hilight_off()
		if curMove.has("add_random_face"):
			var faces : Array = selectedDice.faces
			if faces.count(curMove.add_random_face) == 6:
				pass
			else:
				var chooseable : Array = []
				for curFace in faces.size():
					if faces[curFace] != curMove.add_random_face:
						chooseable.append(curFace)
				faces[chooseable.pick_random()] = curMove.add_random_face
				dice_entered(selectedDice)
				$Button.text = "Continue"



func _on_cancel_button_pressed() -> void:
	curMove = {}
	curChooseable = false
	curDice = null
	for dice in activeDice:
		dice.queue_free()
	activeDice.clear()
	$".".visible = false
	$Button.text = "Cancel"
