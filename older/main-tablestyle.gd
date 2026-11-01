extends Control
var diceScn = preload("res://dice-tablestyle.tscn")
var rng = RandomNumberGenerator.new()
#var diceValue : Array = []
var activeDice : Array = []
var savedDice : Array = []
var scoreGroup: Array = []
var activeScore : int = 0
var savedScore : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	var dicePos = Vector2(30,80)
	savedScore += activeScore
	activeScore = 0
	if activeDice:
		for dice in activeDice:
			if savedDice.has(dice):
				dice.disable()
			if savedDice.has(dice) == false:
				dice.queue_free()
		#diceValue = []
		activeDice = []
		activeDice.append_array(savedDice)
	for i in (6 - savedDice.size()):
		#diceValue.append(rng.randi_range(1,6))
		var diceInst = diceScn.instantiate()
		diceInst.position = dicePos
		diceInst.change_number(rng.randi_range(1,6))
		diceInst.connect("dropped",dropped_dice)
		activeDice.append(diceInst)
		add_child(diceInst)
		dicePos.x += 70
	#for dice in activeDice:
		#diceValue.append(dice.value)

func dropped_dice(droppedDice):
	if droppedDice.save == true && savedDice.has(droppedDice) == false:
		savedDice.append(droppedDice)
	elif droppedDice.save == false:
		savedDice.erase(droppedDice)

	scoreGroup = []
	for dice in savedDice:
		var tempGroup : Array
		if (dice.value == 1 or dice.value == 5) and not dice.neighbors:
			tempGroup.append(dice)
			scoreGroup.append(tempGroup)
		if dice.neighbors:
			tempGroup.append(dice)
			var remNeighbor = false
			while remNeighbor == false:
				var chkTempGrp = tempGroup
				for nDice in tempGroup:
					for neighb in nDice.neighbors:
						if tempGroup.has(neighb) == false:
							tempGroup.append(neighb)
				if chkTempGrp == tempGroup:
					remNeighbor = true
			tempGroup.sort_custom(temp_sort)
			if scoreGroup.has(tempGroup) == false:
				scoreGroup.append(tempGroup)
	figure_score()

	print(scoreGroup)

func temp_sort(a : Object, b : Object):
	var stringA : String = a.to_string()
	var stringB : String = b.to_string()
	if stringA.hash() < stringB.hash():
		return true
	return false

func figure_score():
	activeScore = 0
	var scoring = []
	for diceGroups in scoreGroup:
		scoring = []
		var diceValues : Array
		for dice in diceGroups:
			diceValues.append(dice.value)
		if diceValues.count(5) == 1:
			scoring.append_array([5])
			activeScore += 50
		if diceValues.count(5) == 2:
			scoring.append_array([5,5])
			activeScore += 100
		if diceValues.count(1) == 1:
			scoring.append_array([1])
			activeScore += 100
		if diceValues.count(1) == 2:
			scoring.append_array([1,1])
			activeScore += 200
		if diceValues.count(2) == 3:
			scoring.append_array([2,2,2])
			activeScore += 200
		if diceValues.count(3) == 3:
			scoring.append_array([3,3,3])
			activeScore += 300
		if diceValues.count(2) == 4:
			scoring.append_array([2,2,2,2])
			activeScore += 400
		if diceValues.count(4) == 3:
			scoring.append_array([4,4,4])
			activeScore += 400
		if diceValues.count(5) == 3:
			scoring.append_array([5,5,5])
			activeScore += 500
		if diceValues.count(3) == 4:
			scoring.append_array([3,3,3,3])
			activeScore += 600
		if diceValues.count(6) == 3:
			scoring.append_array([6,6,6])
			activeScore += 600
		if diceValues.count(2) == 5:
			scoring.append_array([2,2,2,2,2])
			activeScore += 800
		if diceValues.count(4) == 4:
			scoring.append_array([4,4,4,4])
			activeScore += 800
		if diceValues.count(5) == 4:
			scoring.append_array([5,5,5,5])
			activeScore += 1000
		if diceValues.count(1) == 3:
			scoring.append_array([1,1,1])
			activeScore += 1000
		if diceValues.has(1) && diceValues.has(2) && diceValues.has(3) && diceValues.has(4) && diceValues.has(5) && diceValues.has(6):
			scoring.append_array([1,2,3,4,5,6])
			activeScore += 1000
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
			scoring.append_array(scoringMix)
			activeScore += 1000
		if diceValues.count(3) == 5:
			scoring.append_array([3,3,3,3])
			activeScore += 1200
		if diceValues.count(6) == 4:
			scoring.append_array([6,6,6,6])
			activeScore += 1200
		if diceValues.count(2) == 6:
			scoring.append_array([2,2,2,2,2,2])
			activeScore += 1600
		if diceValues.count(4) == 5:
			scoring.append_array([4,4,4,4,4])
			activeScore += 1600
		if diceValues.count(5) == 5:
			scoring.append_array([5,5,5,5,5])
			activeScore += 2000
		if diceValues.count(1) == 4:
			scoring.append_array([1,1,1,1])
			activeScore += 2000
		if diceValues.count(3) == 6:
			scoring.append_array([3,3,3,3,3,3])
			activeScore += 2400
		if diceValues.count(6) == 5:
			scoring.append_array([6,6,6,6,6])
			activeScore += 2400
		if diceValues.count(4) == 6:
			scoring.append_array([4,4,4,4,4,4])
			activeScore += 3200
		if diceValues.count(5) == 6:
			scoring.append_array([5,5,5,5,5,5])
			activeScore += 4000
		if diceValues.count(1) == 5:
			scoring.append_array([1,1,1,1,1])
			activeScore += 4000
		if diceValues.count(6) == 6:
			scoring.append_array([6,6,6,6,6,6])
			activeScore += 4800
		if diceValues.count(1) == 6:
			scoring.append_array([1,1,1,1,1,1])
			activeScore += 8000
		#for dice in diceGroups:
	print(scoring)
	print(savedDice)
	for dice in savedDice:
		if scoring.has(dice.value):
			scoring.erase(dice.value)
		elif scoring.has(dice.value) == false:
			#diceGroups.erase(dice)
			savedDice.erase(dice)
	$ScoreLabel.text = str(activeScore)
		
