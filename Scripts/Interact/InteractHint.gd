# InteractHint.gd (optional)
extends Label
class_name InteractHint

func show_hint(msg: String) -> void:
	text = msg
	visible = true

func hide_hint() -> void:
	visible = false
