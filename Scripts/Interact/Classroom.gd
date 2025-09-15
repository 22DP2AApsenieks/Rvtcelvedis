extends Interactable
class_name Classroom

@export var room_id: String = "A101"
@export var title: String = "Intro to Programming"
@export var teacher: String = "Ms. Smith"
@export var subject: String = "Computer Science"
@export_multiline var description: String = "Short description of what is covered in this class."
@export var photo: Texture2D

func _ready() -> void:
	prompt = "Press E to view class"

func interact(_by: Node) -> void:
	_show_class_card()

func _show_class_card() -> void:
	var win := Window.new()
	win.title = "Klase %s" % room_id
	win.size = Vector2i(420, 420)
	win.unresizable = true
	get_tree().current_scene.add_child(win)
	win.popup_centered()

	var root := VBoxContainer.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.offset_left = 12
	root.offset_top = 12
	root.offset_right = -12
	root.offset_bottom = -12
	win.add_child(root)

	var h := Label.new()
	h.text = "%s — %s" % [room_id, title]
	h.add_theme_font_size_override("font_size", 20)
	root.add_child(h)

	var meta := Label.new()
	meta.text = "Skolotājs: %s\nPriekšmets: %s" % [teacher, subject]
	root.add_child(meta)

	if photo:
		var img := TextureRect.new()
		img.texture = photo
		img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		img.custom_minimum_size = Vector2(360, 160)
		root.add_child(img)


	var desc := RichTextLabel.new()
	desc.fit_content = true
	desc.scroll_active = true
	desc.custom_minimum_size = Vector2(360, 140)
	desc.text = description
	root.add_child(desc)

	var close := Button.new()
	close.text = "Close"
	close.pressed.connect(func(): win.queue_free())
	root.add_child(close)
