extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func play():
	$AnimationPlayer.play("farkle")

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	$".".queue_free()
