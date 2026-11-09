extends Node2D
var diceScn = preload("res://dice-slotstyle.tscn")
var farkleScn = preload("res://farkle_anim.tscn")
var rng = RandomNumberGenerator.new()
#var preDice : Array = []
var activeDice : Array = []
var scoringDice : Array = []
var usedSpaces : Array = []
var totalScore : int = 0
var onBoard : int = 1000
var winScore : int = 1500
var score : int = 0
var activeScore : int = 0
var rolls : int = 3
var boxcarWorkaround : bool = false
signal request_dice
signal farkled
signal winRound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func prepare_dice(diceValues : Array, diceWeights : Array, diceColors : Array):
	var toDelete = activeDice
	toDelete.append_array(scoringDice)
	for items in toDelete:
		if items.get_parent():
			remove_child(items)
	activeDice = []
	scoringDice = []
	usedSpaces = []
	activeScore = 0
	for i in 6:
		var diceInst = diceScn.instantiate()
		diceInst.faces = diceValues[i]
		diceInst.weights = diceWeights[i]
		diceInst.color = diceColors[i]
		diceInst.connect("dropped",dropped_dice)
		diceInst.connect("picked",picked_dice)
		activeDice.append(diceInst)


func _on_roll_button_pressed() -> void:
	$RollButton.disabled = true
	$AddButton.disabled = true
	var dicePos = Vector2(34,325)
	boxcarWorkaround = false
	activeDice.append_array(scoringDice)
	scoringDice.clear()
	usedSpaces.clear()
	activeScore = 0
	$Label.text = str(activeScore)
	for preDice in activeDice:
		if preDice.get_parent():
			remove_child(preDice)
		preDice.change_number(preDice.faces[rng.rand_weighted(preDice.weights)])
		preDice.position = dicePos
		add_child(preDice)
		dicePos.x += 80
	if farkle(activeDice):
		$BankButton.disabled = true
		var farkleInst = farkleScn.instantiate()
		add_child(farkleInst)
		farkleInst.play_farkle()
		farkleInst.connect("farked", pass_up_farkle)
		#get_tree().paused = true
		

func pass_up_farkle():
	update_rolls()
	#farkled.emit()


func dropped_dice(emitter : Area2D):
	if emitter.has_overlapping_areas():
		var dist : Array
		var gotoZone
		for zones in emitter.get_overlapping_areas():
			var thisZone = zones.position
			var thisDist = thisZone.distance_to(emitter.global_position)
			dist.append(thisDist)
			if thisDist == dist.min():
				gotoZone = zones
		var moveNode = emitter.owner
		if usedSpaces.has(gotoZone):
			moveNode.position = Vector2((rng.randi_range(30,450)),(rng.randi_range(250,380)))
		elif usedSpaces.has(gotoZone) == false:
			moveNode.position = gotoZone.position + Vector2(4,4)
			usedSpaces.append(gotoZone)
			scoringDice.append(moveNode)
			activeDice.erase(moveNode)
		figure_score()


func picked_dice(emitter : Area2D):
	if emitter.has_overlapping_areas():
		for zones in emitter.get_overlapping_areas():
			usedSpaces.erase(zones)
			#zones.monitorable = true
		var movedNode = emitter.owner
		scoringDice.erase(movedNode)
		activeDice.append(movedNode)
		figure_score()


func _on_add_button_pressed() -> void:
	var removeTheseDice = figure_score()
	for dice in removeTheseDice:
		activeDice.append(dice)
		scoringDice.erase(dice)
	score += activeScore
	if score >= onBoard or totalScore >= onBoard:
		$BankButton.disabled = false
	activeScore = 0
	$Label.text = "0"
	$Label2.text = str(score)
	$RollButton.disabled = false
	$AddButton.disabled = true
	for dice in scoringDice:
		remove_child(dice)
		activeDice.erase(dice)
	if activeDice.size() < 1:
		request_dice.emit()
		var farkleInst = farkleScn.instantiate()
		add_child(farkleInst)
		farkleInst.play_rolling(score)
	scoringDice.clear()
	usedSpaces.clear()


func _on_bank_button_pressed() -> void:
	$BankButton.disabled = true
	totalScore += score
	score = 0
	$Label2.text = str(0)
	$TotalLabel.text = str(totalScore)
	update_rolls()


func update_rolls():
	rolls -= 1
	if rolls <= 0:
		if totalScore < winScore:
			farkled.emit()
		elif totalScore >= winScore:
			winRound.emit(totalScore, winScore)
	elif rolls > 0:
		$RollsLabel.text = str(rolls)
		score = 0
		$Label2.text = str(score)
		request_dice.emit()
		$AddButton.disabled = true
		$BankButton.disabled = true
		$RollButton.disabled = false


func figure_score():
	var diceValues : Array = []
	activeScore = 0
	for dice in scoringDice:
		diceValues.append(dice.value)
	if diceValues.count(1) == 6:
		diceValues.erase(1)
		diceValues.erase(1)
		diceValues.erase(1)
		diceValues.erase(1)
		diceValues.erase(1)
		diceValues.erase(1)
		activeScore += 8000
	if diceValues.count(6) == 6:
		diceValues.erase(6)
		diceValues.erase(6)
		diceValues.erase(6)
		diceValues.erase(6)
		diceValues.erase(6)
		diceValues.erase(6)
		activeScore += 4800
	if diceValues.count(1) == 5:
		diceValues.erase(1)
		diceValues.erase(1)
		diceValues.erase(1)
		diceValues.erase(1)
		diceValues.erase(1)
		activeScore += 4000
	if diceValues.count(5) == 6:
		diceValues.erase(5)
		diceValues.erase(5)
		diceValues.erase(5)
		diceValues.erase(5)
		diceValues.erase(5)
		diceValues.erase(5)
		activeScore += 4000
	if diceValues.count(4) == 6:
		diceValues.erase(4)
		diceValues.erase(4)
		diceValues.erase(4)
		diceValues.erase(4)
		diceValues.erase(4)
		diceValues.erase(4)
		activeScore += 3200
	if diceValues.count(6) == 5:
		diceValues.erase(6)
		diceValues.erase(6)
		diceValues.erase(6)
		diceValues.erase(6)
		diceValues.erase(6)
		activeScore += 2400
	if diceValues.count(3) == 6:
		diceValues.erase(3)
		diceValues.erase(3)
		diceValues.erase(3)
		diceValues.erase(3)
		diceValues.erase(3)
		diceValues.erase(3)
		activeScore += 2400
	if diceValues.count(1) == 4:
		diceValues.erase(1)
		diceValues.erase(1)
		diceValues.erase(1)
		diceValues.erase(1)
		activeScore += 2000
	if diceValues.count(5) == 5:
		diceValues.erase(5)
		diceValues.erase(5)
		diceValues.erase(5)
		diceValues.erase(5)
		diceValues.erase(5)
		activeScore += 2000
	if diceValues.count(4) == 5:
		diceValues.erase(4)
		diceValues.erase(4)
		diceValues.erase(4)
		diceValues.erase(4)
		diceValues.erase(4)
		activeScore += 1600
	if diceValues.count(2) == 6:
		diceValues.erase(2)
		diceValues.erase(2)
		diceValues.erase(2)
		diceValues.erase(2)
		diceValues.erase(2)
		diceValues.erase(2)
		activeScore += 1600
	if diceValues.count(6) == 4:
		diceValues.erase(6)
		diceValues.erase(6)
		diceValues.erase(6)
		diceValues.erase(6)
		activeScore += 1200
	if diceValues.count(3) == 5:
		diceValues.erase(3)
		diceValues.erase(3)
		diceValues.erase(3)
		diceValues.erase(3)
		activeScore += 1200
	var boxcarPairs = 0
	var scoringMix : Array = []
	if diceValues.count(1) >= 2:
		boxcarPairs += 1
		scoringMix.append_array([1,1])
		if diceValues.count(1) >= 4:
			boxcarPairs += 1
			scoringMix.append_array([1,1])
		if diceValues.count(1) >= 6:
			boxcarPairs += 1
			scoringMix.append_array([1,1])
	if diceValues.count(2) >= 2:
		boxcarPairs += 1
		scoringMix.append_array([2,2])
		if diceValues.count(2) >= 4:
			boxcarPairs += 1
			scoringMix.append_array([2,2])
		if diceValues.count(2) >= 6:
			boxcarPairs += 1
			scoringMix.append_array([2,2])
	if diceValues.count(3) >= 2:
		boxcarPairs += 1
		scoringMix.append_array([3,3])
		if diceValues.count(3) >= 4:
			boxcarPairs += 1
			scoringMix.append_array([3,3])
		if diceValues.count(3) >= 6:
			boxcarPairs += 1
			scoringMix.append_array([3,3])
	if diceValues.count(4) >= 2:
		boxcarPairs += 1
		scoringMix.append_array([4,4])
		if diceValues.count(4) >= 4:
			boxcarPairs += 1
			scoringMix.append_array([4,4])
		if diceValues.count(4) >= 6:
			boxcarPairs += 1
			scoringMix.append_array([4,4])
	if diceValues.count(5) >= 2:
		boxcarPairs += 1
		scoringMix.append_array([5,5])
		if diceValues.count(5) >= 4:
			boxcarPairs += 1
			scoringMix.append_array([5,5])
		if diceValues.count(5) >= 6:
			boxcarPairs += 1
			scoringMix.append_array([5,5])
	if diceValues.count(6) >= 2:
		boxcarPairs += 1
		scoringMix.append_array([6,6])
		if diceValues.count(6) >= 4:
			boxcarPairs += 1
			scoringMix.append_array([6,6])
		if diceValues.count(6) >= 6:
			boxcarPairs += 1
			scoringMix.append_array([6,6])
	if boxcarPairs == 3:
		for value in scoringMix:
			diceValues.erase(value)
		activeScore += 1000
	if diceValues.has(1) && diceValues.has(2) && diceValues.has(3) && diceValues.has(4) && diceValues.has(5) && diceValues.has(6):
		diceValues.erase(1)
		diceValues.erase(2)
		diceValues.erase(3)
		diceValues.erase(4)
		diceValues.erase(5)
		diceValues.erase(6)
		activeScore += 1000
	if diceValues.count(1) == 3:
		diceValues.erase(1)
		diceValues.erase(1)
		diceValues.erase(1)
		activeScore += 1000
	if diceValues.count(5) == 4:
		diceValues.erase(5)
		diceValues.erase(5)
		diceValues.erase(5)
		diceValues.erase(5)
		activeScore += 1000
	if diceValues.count(4) == 4:
		diceValues.erase(4)
		diceValues.erase(4)
		diceValues.erase(4)
		diceValues.erase(4)
		activeScore += 800
	if diceValues.count(2) == 5:
		diceValues.erase(2)
		diceValues.erase(2)
		diceValues.erase(2)
		diceValues.erase(2)
		diceValues.erase(2)
		activeScore += 800
	if diceValues.count(6) == 3:
		diceValues.erase(6)
		diceValues.erase(6)
		diceValues.erase(6)
		activeScore += 600
	if diceValues.count(3) == 4:
		diceValues.erase(3)
		diceValues.erase(3)
		diceValues.erase(3)
		diceValues.erase(3)
		activeScore += 600
	if diceValues.count(5) == 3:
		diceValues.erase(5)
		diceValues.erase(5)
		diceValues.erase(5)
		activeScore += 500
	if diceValues.count(4) == 3:
		diceValues.erase(4)
		diceValues.erase(4)
		diceValues.erase(4)
		activeScore += 400
	if diceValues.count(2) == 4:
		diceValues.erase(2)
		diceValues.erase(2)
		diceValues.erase(2)
		diceValues.erase(2)
		activeScore += 400
	if diceValues.count(3) == 3:
		diceValues.erase(3)
		diceValues.erase(3)
		diceValues.erase(3)
		activeScore += 300
	if diceValues.count(2) == 3:
		diceValues.erase(2)
		diceValues.erase(2)
		diceValues.erase(2)
		activeScore += 200
	if diceValues.count(1) == 2:
		diceValues.erase(1)
		diceValues.erase(1)
		activeScore += 200
	if diceValues.count(1) == 1:
		diceValues.erase(1)
		activeScore += 100
	if diceValues.count(5) == 2:
		diceValues.erase(5)
		diceValues.erase(5)
		activeScore += 100
	if diceValues.count(5) == 1:
		diceValues.erase(5)
		activeScore += 50
		
	if diceValues.is_empty() == false and boxcarWorkaround == true:
		var spdiceValues : Array = []
		for dice in scoringDice:
			spdiceValues.append(dice.value)
		if spdiceValues.size() == 6:
			diceValues.clear()
			activeScore = 1000
			
		
	$Label.text = str(activeScore)
	if activeScore > 0:
		$AddButton.disabled = false
	elif  activeScore == 0:
		$AddButton.disabled = true
	
	var NotThese : Array = []
	for nonDice in diceValues:
		for dice in scoringDice:
			if dice.value == nonDice:
				NotThese.append(dice)
	return NotThese
		

func farkle(farkleDicetoCheck):
	var farkleValues : Array = []
	var farkleBool : bool = true
	for dice in farkleDicetoCheck:
		farkleValues.append(dice.value)
	if farkleValues.has(5):
		farkleBool = false
	if farkleValues.has(1):
		farkleBool = false
	if farkleValues.count(1) >= 3:
		farkleBool = false
	if farkleValues.count(2) >= 3:
		farkleBool = false
	if farkleValues.count(3) >= 3:
		farkleBool = false
	if farkleValues.count(4) >= 3:
		farkleBool = false
	if farkleValues.count(5) >= 3:
		farkleBool = false
	if farkleValues.count(6) >= 3:
		farkleBool = false
	if farkleValues.has(1) && farkleValues.has(2) && farkleValues.has(3) && farkleValues.has(4) && farkleValues.has(5) && farkleValues.has(6):
		farkleBool = false
	var boxcarPairs = 0
	if farkleValues.count(1) >= 2:
		boxcarPairs += 1
		if farkleValues.count(1) >= 4:
			boxcarPairs += 1
		if farkleValues.count(1) >= 6:
			boxcarPairs += 1
	if farkleValues.count(2) >= 2:
		boxcarPairs += 1
		if farkleValues.count(2) >= 4:
			boxcarPairs += 1
		if farkleValues.count(2) >= 6:
			boxcarPairs += 1
	if farkleValues.count(3) >= 2:
		boxcarPairs += 1
		if farkleValues.count(3) >= 4:
			boxcarPairs += 1
		if farkleValues.count(3) >= 6:
			boxcarPairs += 1
	if farkleValues.count(4) >= 2:
		boxcarPairs += 1
		if farkleValues.count(4) >= 4:
			boxcarPairs += 1
		if farkleValues.count(4) >= 6:
			boxcarPairs += 1
	if farkleValues.count(5) >= 2:
		boxcarPairs += 1
		if farkleValues.count(5) >= 4:
			boxcarPairs += 1
		if farkleValues.count(5) >= 6:
			boxcarPairs += 1
	if farkleValues.count(6) >= 2:
		boxcarPairs += 1
		if farkleValues.count(6) >= 4:
			boxcarPairs += 1
		if farkleValues.count(6) >= 6:
			boxcarPairs += 1
	if boxcarPairs == 3:
		var farkleInst = farkleScn.instantiate()
		add_child(farkleInst)
		farkleInst.play_boxcars()
		farkleBool = false
		boxcarWorkaround = true
	return farkleBool
	
