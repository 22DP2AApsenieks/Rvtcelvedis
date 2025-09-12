# Toilet.gd
extends Interactable
@export var toilet_id: String = "toilet-A"

func _ready() -> void:
	prompt = "Press E to rate toilet"

func interact(_by: Node) -> void:
	_show_rating_ui()

func _show_rating_ui() -> void:
	var summary := Ratings.get_toilet_info(toilet_id)
	var avg := float(summary.get("avg", 0.0))
	var count := int(summary.get("count", 0))

	var win := Window.new()
	win.title = "Toilet rating"
	win.size = Vector2i(340, 180)
	win.unresizable = true
	get_tree().current_scene.add_child(win)

	var vb := VBoxContainer.new()
	vb.anchor_right = 1.0
	vb.anchor_bottom = 1.0
	vb.grow_horizontal = Control.GROW_DIRECTION_BOTH
	vb.grow_vertical = Control.GROW_DIRECTION_BOTH
	vb.offset_left = 12; vb.offset_top = 12; vb.offset_right = -12; vb.offset_bottom = -12
	win.add_child(vb)

	var label := Label.new()
	label.text = "Current avg: %.1f ★  (%d votes)" % [avg, count]
	vb.add_child(label)

	var stars := HBoxContainer.new()
	stars.alignment = BoxContainer.ALIGNMENT_CENTER
	vb.add_child(stars)

	for i in range(1, 6):
		var b := Button.new()
		b.text = "★ %d" % i
		b.tooltip_text = "Rate %d stars" % i
		b.pressed.connect(func():
			var res := Ratings.submit_toilet_rating(toilet_id, i)
			label.text = "Current avg: %.1f ★  (%d votes)\nYour rating: %d ★" % [float(res.get("avg", 0.0)), int(res.get("count", 0)), int(res.get("yours", 0))])
		stars.add_child(b)

	var close := Button.new()
	close.text = "Close"
	close.pressed.connect(func(): win.queue_free())
	vb.add_child(close)

	win.popup_centered()
