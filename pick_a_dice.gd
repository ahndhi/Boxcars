extends Control
var diceScn = preload("res://dice-slotstyle.tscn")
var curMove : Dictionary = {}
var curChooseable : bool = false
var curDice : Node = null
var activeDice : Array = []
var activeFaces : Array = []

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
		dicePos = Vector2(58,160)
		$DirectionsLabel.text = "Select a dice, then select a face."
	if chooseFace == false:
		dicePos = Vector2(58,440)
		$DirectionsLabel.text = "Select a dice."
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
		diceStats += str(emitter.faces[i]) + " / " + str(snapped(emitter.weights[i],0.1) * 100) + "%\n"
	for i in range(3,6):
		diceStats2 += str(emitter.faces[i]) + " / " + str(snapped(emitter.weights[i],0.1) * 100) + "%\n"
	$StatsLabel.text = diceStats
	$StatsLabel2.text = diceStats2


func dice_exited():
	$StatsLabel.text = ""
	$StatsLabel2.text = ""


func face_entered(emitter):
	$FaceStats.text = str(snapped(emitter.weights[0], 0.1) * 100)


func face_exited():
	$FaceStats.text = ""

func face_selected(emitter):
	var selectedFace = emitter.owner
	var faceIndex : int = activeFaces.find(selectedFace)
	for dice in activeDice:
		dice.select_hilight_off()
	if curMove.has("adjust_odds"):
		curDice.weights[faceIndex] += curMove.adjust_odds
		selectedFace.weights[0] = curDice.weights[faceIndex]
		face_entered(selectedFace)
		for face in activeFaces:
			face.disable_click()
		for dice in activeDice:
			dice.disable_click()
		$Button.text = "Continue"
	
	

func dice_selected(emitter):
	var selectedDice = emitter.owner
	curDice = selectedDice
	if curChooseable == true:
		for face in activeFaces:
			face.queue_free()
		activeFaces.clear()
		for dice in activeDice:
			dice.select_hilight_off()
		selectedDice.select_hilight_on()
		var weightCounter : int = 0
		var facePos : Vector2 = Vector2(136,500)
		for face in selectedDice.faces:
			var faceInst = diceScn.instantiate()
			faceInst.position = facePos
			faceInst.weights.append(selectedDice.weights[weightCounter])
			weightCounter += 1
			faceInst.change_number(face)
			faceInst.movable = false
			faceInst.connect("mouseIn",face_entered)
			faceInst.connect("mouseOut",face_exited)
			faceInst.connect("picked", face_selected)
			activeFaces.append(faceInst)
			add_child(faceInst)
			facePos.x += 102
			if facePos.x == 442:
				facePos = Vector2(136,600)
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
				for face in activeFaces:
					face.disable_click()
				for dice in activeDice:
					dice.disable_click()
				$Button.text = "Continue"



func _on_cancel_button_pressed() -> void:
	curMove = {}
	curChooseable = false
	curDice = null
	for face in activeFaces:
		face.queue_free()
	activeFaces.clear()
	for dice in activeDice:
		dice.queue_free()
	activeDice.clear()
	$".".visible = false
	$Button.text = "Cancel"
