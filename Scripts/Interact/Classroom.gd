# Classroom.gd
extends Interactable

@export var room_id: String = "RVT-101"
@export_multiline var info: String = "Teacher: ...\nSubject: ...\nSchedule: ..."

func _ready() -> void:
	prompt = "Press E to view classroom info"

func interact(_by: Node) -> void:
	_show_info()

func _show_info() -> void:
	var win := Window.new()
	win.title = room_id
	win.size = Vector2i(360, 240)
	win.unresizable = true
	get_tree().current_scene.add_child(win)

	var vb := VBoxContainer.new()
	vb.anchor_right = 1.0
	vb.anchor_bottom = 1.0
	vb.grow_horizontal = Control.GROW_DIRECTION_BOTH
	vb.grow_vertical = Control.GROW_DIRECTION_BOTH
	vb.offset_left = 12; vb.offset_top = 12; vb.offset_right = -12; vb.offset_bottom = -12
	win.add_child(vb)

	var label := RichTextLabel.new()
	label.fit_content = true
	label.bbcode_enabled = true
	label.text = "[b]%s[/b]\n\n%s" % [room_id, info]
	vb.add_child(label)

	var close := Button.new()
	close.text = "Close"
	close.pressed.connect(func(): win.queue_free())
	vb.add_child(close)

	win.popup_centered()
