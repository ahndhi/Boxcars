extends Node2D
signal farked


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func play_farkle():
	$Label.text = "FARKLE!"
	$Label.add_theme_color_override("font_color", Color(1.0, 0.424, 0.855, 1.0))
	$AnimationPlayer.play("farkle")

func play_boxcars():
	$Label.text = "BOXCARS!!!"
	$Label.add_theme_color_override("font_color", Color(0.992, 0.635, 0.286, 1.0))
	$AnimationPlayer.play("farkle")

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	farked.emit()
	$".".queue_free()
