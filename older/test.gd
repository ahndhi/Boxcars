extends Control
var one = [["green","blue","red","bleu"],["blue"]]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	var two = ["blue", "bleu","red", "green"]
	two.sort()
	one[0].sort()
	if one.has(two):
		print("does")
		print(two)
