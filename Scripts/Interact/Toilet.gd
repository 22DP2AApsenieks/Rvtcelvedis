extends Interactable
class_name Toilet

@export var toilet_id: String = "toilet-A"

func _ready() -> void:
	prompt = "Press E to rate toilet"

func interact(_by: Node) -> void:
	_show_rating_ui(toilet_id)

func _show_rating_ui(id: String) -> void:
	var info := Ratings.get_toilet_info(id)
	var avg  := float(info.get("avg", 0.0))
	var cnt  := int(info.get("count", 0))

	var win := Window.new()
	win.title = "Toilet rating"
	win.size = Vector2i(360, 200)
	win.unresizable = true
	get_tree().current_scene.add_child(win)  # or add_child(win) if Toilet is in the same scene
	win.popup_centered()

	var vb := VBoxContainer.new()
	vb.set_anchors_preset(Control.PRESET_FULL_RECT)
	vb.offset_left = 12
	vb.offset_top = 12
	vb.offset_right = -12
	vb.offset_bottom = -12
	win.add_child(vb)

	var header := Label.new()
	header.text = "Current avg: %.1f ★  (%d votes)" % [avg, cnt]
	vb.add_child(header)

# stars row
	var stars := HBoxContainer.new()
	stars.alignment = BoxContainer.ALIGNMENT_CENTER
	vb.add_child(stars)

	for i in range(1, 6):  # 1..5
		var b := Button.new()
		b.text = "★ %d" % i
		b.tooltip_text = "Rate %d stars" % i
		b.pressed.connect(func():
			var vote := Ratings.submit_toilet_rating(id, i)
			var new_avg := float(vote.get("avg", 0.0))
			var new_cnt := int(vote.get("count", 0))
			var your    := int(vote.get("yours", 0))
			header.text = "Current avg: %.1f ★  (%d votes)\nYour rating: %d ★" % [new_avg, new_cnt, your])
		stars.add_child(b)


	var close := Button.new()
	close.text = "Close"
	close.pressed.connect(func(): win.queue_free())
	vb.add_child(close)
