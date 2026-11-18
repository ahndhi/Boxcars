extends Control
var visiblePaths : Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func show_choices(curStop : int):
	if curStop == 1:
		$TextureRect1.use_parent_material = false
		$TextureRect1.visible = true
		$TextureRect2.use_parent_material = false
		$TextureRect2.visible = true
	if curStop == 2:
		$TextureRect3.use_parent_material = false
		$TextureRect3.visible = true
	if curStop == 3:
		$TextureRect4.use_parent_material = false
		$TextureRect4.visible = true
	if curStop == 4:
		$TextureRect5.use_parent_material = false
		$TextureRect5.visible = true
		$TextureRect6.use_parent_material = false
		$TextureRect6.visible = true
	if curStop == 5:
		$TextureRect7.use_parent_material = false
		$TextureRect7.visible = true
		$TextureRect8.use_parent_material = false
		$TextureRect8.visible = true
	if curStop == 6:
		$TextureRect9.use_parent_material = false
		$TextureRect9.visible = true
	if curStop == 7:
		$TextureRect10.use_parent_material = false
		$TextureRect10.visible = true
	if curStop == 8:
		$TextureRect11.use_parent_material = false
		$TextureRect11.visible = true
	if curStop == 9:
		$TextureRect12.use_parent_material = false
		$TextureRect12.visible = true
	if curStop == 10:
		$TextureRect13.use_parent_material = false
		$TextureRect13.visible = true
		$TextureRect14.use_parent_material = false
		$TextureRect14.visible = true
		$TextureRect15.use_parent_material = false
		$TextureRect15.visible = true
	if curStop == 11:
		$TextureRect16.use_parent_material = false
		$TextureRect16.visible = true
	if curStop == 12:
		$TextureRect17.use_parent_material = false
		$TextureRect17.visible = true
	if curStop == 13:
		$TextureRect18.use_parent_material = false
		$TextureRect18.visible = true
		$TextureRect19.use_parent_material = false
		$TextureRect19.visible = true
	if curStop == 14:
		$TextureRect20.use_parent_material = false
		$TextureRect20.visible = true
	if curStop == 15:
		$TextureRect21.use_parent_material = false
		$TextureRect21.visible = true
	if curStop == 16:
		$TextureRect22.use_parent_material = false
		$TextureRect22.visible = true

func update_paths(newPath : int = 0):
	if newPath != 0:
		if not visiblePaths.has(newPath) and newPath <= 22:
			visiblePaths.append(newPath)
	for i in 22:
		var curPath = get_node("TextureRect" + str(i+1))
		curPath.visible = false
		curPath.use_parent_material = true
	for path in visiblePaths:
		var curPath = get_node("TextureRect" + str(path))
		curPath.visible = true
