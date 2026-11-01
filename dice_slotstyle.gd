extends Node2D
var grabbed : bool = false
var slot : Vector2
var value : int
var faces : Array = []
var weights : PackedFloat32Array = []
var color : Color = Color("d32a01ff")
signal dropped(emittingNode)
signal picked(emittingNode)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var panel : StyleBoxFlat = $ColorPanel.get_theme_stylebox("panel")
	panel.bg_color = color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if grabbed == true:
		$".".position = get_global_mouse_position() + Vector2(-32,-32)


func _on_button_button_down() -> void:
	grabbed = true
	picked.emit($SaveArea)



func _on_button_button_up() -> void:
	grabbed = false
	dropped.emit($SaveArea)


#func _on_save_area_area_entered(area: Area2D) -> void:
	#slot = area.position + Vector2(4,4)
#
#
#func _on_save_area_area_exited(_area: Area2D) -> void:
	#if $SaveArea.has_overlapping_areas() == false:
		#slot = Vector2(0,0)

func change_number(face):
	$Button.text = str(face)
	value = face
