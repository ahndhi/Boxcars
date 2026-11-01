extends Control
var grabbed : bool = false
var save : bool = false
var value : int = 0
var neighbors : Array = []
signal dropped(EmittingDice)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if grabbed == true:
		$".".position = get_global_mouse_position() + Vector2(-20,-20)


func _on_button_button_down() -> void:
	grabbed = true


func _on_button_button_up() -> void:
	dropped.emit($".")
	grabbed = false

func change_number(recNum):
	value = recNum
	$Button.text = str(recNum)


func _on_save_area_area_entered(_area: Area2D) -> void:
	save = true

func _on_save_area_area_exited(_area: Area2D) -> void:
	save = false


func _on_score_area_area_entered(area: Area2D) -> void:
	var affector = area.get_parent()
	neighbors.append(affector)

func _on_score_area_area_exited(area: Area2D) -> void:
	var affector = area.get_parent()
	neighbors.erase(affector)

func disable():
	$Button.disabled = true
	$SaveArea.monitoring = false
	$SaveArea.monitorable = false
	$ScoreArea.monitoring = false
	$ScoreArea.monitorable = false
