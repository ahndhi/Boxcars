extends Control
var diceScn = preload("res://dice-slotstyle.tscn")
var activeDice : Array = []
var money : int = 0
signal storeContinue
signal itemBought(value)

var itemScn = preload("res://shop_item.tscn")
var activeItems : Array = []
var waitForDice = null
#var waitForItem = null
#image : Texture2D, title : String, decription : String, price : int, action : Dictionary
var items = [
	{
		"image" : preload("res://art/spider-eyes.png"),
		"title" : "Spider Eyes",
		"description" : "Spider Eyes will transform one random side of the selected die to 6.",
		"price" : 666,
		"action" : {"add_random_face" : 6}
	},
	{
		"image" : preload("res://art/cyclops.png"),
		"title" : "The Cyclops",
		"description" : "The Cyclops will transform one random side of the selected die to 1.",
		"price" : 1111,
		"action" : {"add_random_face" : 1}
	},
	{
		"image" : preload("res://art/pentacles.png"),
		"title" : "Pentacles",
		"description" : "Pentacles will transform one random side of the selected die to 5.",
		"price" : 555,
		"action" : {"add_random_face" : 5}
	},
	{
		"image" : preload("res://art/load.png"),
		"title" : "Loaded",
		"description" : "Loaded will adjust the odds of one chosen side of a selected die by +10%",
		"price" : 800,
		"action" : {"adjust_odds" : 0.1}
	},
	{
		"image" : preload("res://art/shave.png"),
		"title" : "Shaved",
		"description" : "Shaved will adjust the odds of one chosen side of a selected die by -10%",
		"price" : 800,
		"action" : {"adjust_odds" : -0.1}
	}
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func prepare_store(diceValues : Array, diceWeights : Array, diceColors : Array, rcvMoney : int):
	activeDice = []
	money = rcvMoney
	$MoneyLabel.text = "$" + str(money)
	var dicePos = Vector2(58,120)
	var itemPos = Vector2(50,329)
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
		$DiceContainer.add_child(diceInst)
		dicePos.x += 72
	if activeItems.is_empty() == false:
		for item in activeItems:
			item.queue_free()
		activeItems.clear()
	for i in 2:
		var itemInst = itemScn.instantiate()
		itemInst.prep_item(items.pick_random())
		itemInst.position = itemPos
		itemInst.connect("item_bought", on_item_bought)
		itemPos.x += 228
		activeItems.append(itemInst)
		$ItemContainer.add_child(itemInst)


func on_item_bought(value, move, emitter):
	if (money - value) < 0:
		return
	var diceFaces : Array = []
	var diceWeights : Array = []
	var diceColors : Array = []
	for dice in activeDice:
		diceFaces.append(dice.faces)
		diceWeights.append(dice.weights)
		diceColors.append(dice.color)
	if move.has("add_random_face"):
		$PickADice.prepare_pick_a_dice(diceFaces, diceWeights, diceColors, false, move)
		$PickADice.visible = true
		#waitForDice = move
		#$PausePanel.visible = true
		#waitForItem = emitter
	if move.has("adjust_odds"):
		$PickADice.prepare_pick_a_dice(diceFaces, diceWeights, diceColors, true, move)
		$PickADice.visible = true
	activeItems.erase(emitter)
	emitter.queue_free()
	money -= value
	$MoneyLabel.text = "$" + str(money)
	itemBought.emit(money)


func dice_selected(emitter):
	if waitForDice is Dictionary:
		var dice = emitter.owner
		if waitForDice.has("add_random_face"):
			var faces : Array = dice.faces
			if faces.count(waitForDice.add_random_face) == 6:
				pass
			else:
				var chooseable : Array = []
				for curFace in faces.size():
					if faces[curFace] != waitForDice.add_random_face:
						chooseable.append(curFace)
				faces[chooseable.pick_random()] = waitForDice.add_random_face
				dice_entered(dice)
				$PausePanel.visible = false
				#activeItems.erase(waitForItem)
				#waitForItem.queue_free()
				#waitForItem = null


func _on_continue_button_pressed() -> void:
	storeContinue.emit()


func _on_timer_timeout() -> void:
	for dice in activeDice:
		dice.change_number(dice.faces.pick_random())



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


func _on_close_button_pressed() -> void:
	waitForDice = null
	$PausePanel.visible = false
