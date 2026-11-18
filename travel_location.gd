extends Control

@export var iconFile = load("res://art/boss-icon.png")
@export var title : String = ""
@export_multiline var description : String = ""
signal button_pressed(emitter)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextureRect.texture = iconFile


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	$InfoPanel/TitleLabel.text = title
	$InfoPanel/DescRichLabel.text = description
	$InfoPanel.global_position = Vector2(90,300)
	$InfoPanel.visible = true


func _on_mouse_exited() -> void:
	$InfoPanel/TitleLabel.text = ""
	$InfoPanel/DescRichLabel.text = ""
	$InfoPanel.visible = false

func complete():
	$InfoPanel/Completed.visible = true


func _on_button_pressed() -> void:
	button_pressed.emit($".")
