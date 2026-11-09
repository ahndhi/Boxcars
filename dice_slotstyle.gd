extends Node2D
var grabbed : bool = false
var movable : bool = true
var slot : Vector2
var value : int
var faces : Array = []
var weights : PackedFloat32Array = []
var color : Color = Color("d32a01ff")
var shaderTime : float
var shaderMat : ShaderMaterial
signal dropped(emittingNode)
signal picked(emittingNode)
signal mouseIn(emittingNode)
signal mouseOut

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shaderMat = $ColorPanel.material
	var panel : StyleBoxFlat = $ColorPanel.get_theme_stylebox("panel")
	panel.bg_color = color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if grabbed == true and movable == true:
		$".".position = get_global_mouse_position() + Vector2(-32,-32)
		#shaderTime += delta * 2
	#elif grabbed == false:
		#shaderTime = 0.0
	#$ColorPanel.set_instance_shader_parameter("progress",shaderTime)


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

func select_hilight_on():
	$SelectPanel.visible = true

func select_hilight_off():
	$SelectPanel.visible = false


func _on_button_mouse_entered() -> void:
	mouseIn.emit($".")


func _on_button_mouse_exited() -> void:
	mouseOut.emit()
