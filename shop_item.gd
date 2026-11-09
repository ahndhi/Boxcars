extends Control
signal item_bought(price,action,emitter)
var value : int = 0
var move : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func prep_item(itemDictEnt : Dictionary):
	$Image.texture = itemDictEnt.image
	$TitleLabel.text = itemDictEnt.title
	$DescLabel.text = itemDictEnt.description
	value = itemDictEnt.price
	$BuyButton.text = "BUY $" + str(value)
	move = itemDictEnt.action

func _on_buy_button_pressed() -> void:
	item_bought.emit(value, move, $".")
