extends Node2D
var diceValues : Array = []
var today = Time.get_date_dict_from_system()
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clear_combos()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func clear_combos():
	for item in 28:
		$ItemList.set_item_disabled(item, true)
	$ItemList.deselect_all()

func determine_combos():
	if diceValues.count(5) >= 1:
		$ItemList.set_item_disabled(0, false)
	if diceValues.count(1) >= 1:
		$ItemList.set_item_disabled(1, false)
	if diceValues.count(2) >= 3:
		$ItemList.set_item_disabled(2, false)
	if diceValues.count(3) >= 3:
		$ItemList.set_item_disabled(3, false)
	if diceValues.count(2) >= 4:
		$ItemList.set_item_disabled(4, false)
	if diceValues.count(4) >= 3:
		$ItemList.set_item_disabled(5, false)
	if diceValues.count(5) >= 3:
		$ItemList.set_item_disabled(6, false)
	if diceValues.count(3) >= 4:
		$ItemList.set_item_disabled(7, false)
	if diceValues.count(6) >= 3:
		$ItemList.set_item_disabled(8, false)
	if diceValues.count(2) >= 5:
		$ItemList.set_item_disabled(9, false)
	if diceValues.count(4) >= 4:
		$ItemList.set_item_disabled(10, false)
	if diceValues.count(5) >= 4:
		$ItemList.set_item_disabled(11, false)
	if diceValues.count(1) >= 3:
		$ItemList.set_item_disabled(12, false)
	if diceValues.has(1) && diceValues.has(2) && diceValues.has(3) && diceValues.has(4) && diceValues.has(5) && diceValues.has(6):
		$ItemList.set_item_disabled(13, false)
	var boxcarPairs = 0
	if diceValues.count(1) >= 2:
		boxcarPairs += 1
		if diceValues.count(1) >= 4:
			boxcarPairs += 1
		if diceValues.count(1) >= 6:
			boxcarPairs += 1
	if diceValues.count(2) >= 2:
		boxcarPairs += 1
		if diceValues.count(2) >= 4:
			boxcarPairs += 1
		if diceValues.count(2) >= 6:
			boxcarPairs += 1
	if diceValues.count(3) >= 2:
		boxcarPairs += 1
		if diceValues.count(3) >= 4:
			boxcarPairs += 1
		if diceValues.count(3) >= 6:
			boxcarPairs += 1
	if diceValues.count(4) >= 2:
		boxcarPairs += 1
		if diceValues.count(4) >= 4:
			boxcarPairs += 1
		if diceValues.count(4) >= 6:
			boxcarPairs += 1
	if diceValues.count(5) >= 2:
		boxcarPairs += 1
		if diceValues.count(5) >= 4:
			boxcarPairs += 1
		if diceValues.count(5) >= 6:
			boxcarPairs += 1
	if diceValues.count(6) >= 2:
		boxcarPairs += 1
		if diceValues.count(6) >= 4:
			boxcarPairs += 1
		if diceValues.count(6) >= 6:
			boxcarPairs += 1
	if boxcarPairs == 3:
		$ItemList.set_item_disabled(14, false)
	if diceValues.count(3) >= 5:
		$ItemList.set_item_disabled(15, false)
	if diceValues.count(6) >= 4:
		$ItemList.set_item_disabled(16, false)
	if diceValues.count(2) >= 6:
		$ItemList.set_item_disabled(17, false)
	if diceValues.count(4) >= 5:
		$ItemList.set_item_disabled(18, false)
	if diceValues.count(5) >= 5:
		$ItemList.set_item_disabled(19, false)
	if diceValues.count(1) >= 4:
		$ItemList.set_item_disabled(20, false)
	if diceValues.count(3) >= 6:
		$ItemList.set_item_disabled(21, false)
	if diceValues.count(6) >= 5:
		$ItemList.set_item_disabled(22, false)
	if diceValues.count(4) >= 6:
		$ItemList.set_item_disabled(23, false)
	if diceValues.count(5) >= 6:
		$ItemList.set_item_disabled(24, false)
	if diceValues.count(1) >= 5:
		$ItemList.set_item_disabled(25, false)
	if diceValues.count(6) >= 6:
		$ItemList.set_item_disabled(26, false)
	if diceValues.count(1) >= 6:
		$ItemList.set_item_disabled(27, false)

func _on_button_pressed() -> void:
	#$Button.disabled = true
	clear_combos()
	diceValues = []
	$Dice1.text = str(rng.randi_range(1,6))
	$Dice1.set_pressed_no_signal(false)
	$Dice1.disabled = false
	$Dice2.text = str(rng.randi_range(1,6))
	$Dice2.set_pressed_no_signal(false)
	$Dice2.disabled = false
	$Dice3.text = str(rng.randi_range(1,6))
	$Dice3.set_pressed_no_signal(false)
	$Dice3.disabled = false
	$Dice4.text = str(rng.randi_range(1,6))
	$Dice4.set_pressed_no_signal(false)
	$Dice4.disabled = false
	$Dice5.text = str(rng.randi_range(1,6))
	$Dice5.set_pressed_no_signal(false)
	$Dice5.disabled = false
	$Dice6.text = str(rng.randi_range(1,6))
	$Dice6.set_pressed_no_signal(false)
	$Dice6.disabled = false
		


func _on_dice_1_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		diceValues.append(int($Dice1.text))
		determine_combos()
	else:
		diceValues.erase(int($Dice1.text))
		clear_combos()
		determine_combos()


func _on_dice_2_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		diceValues.append(int($Dice2.text))
		determine_combos()
	else:
		diceValues.erase(int($Dice2.text))
		clear_combos()
		determine_combos()


func _on_dice_3_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		diceValues.append(int($Dice3.text))
		determine_combos()
	else:
		diceValues.erase(int($Dice3.text))
		clear_combos()
		determine_combos()


func _on_dice_4_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		diceValues.append(int($Dice4.text))
		determine_combos()
	else:
		diceValues.erase(int($Dice4.text))
		clear_combos()
		determine_combos()


func _on_dice_5_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		diceValues.append(int($Dice5.text))
		determine_combos()
	else:
		diceValues.erase(int($Dice5.text))
		clear_combos()
		determine_combos()


func _on_dice_6_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		diceValues.append(int($Dice6.text))
		determine_combos()
	else:
		diceValues.erase(int($Dice6.text))
		clear_combos()
		determine_combos()
