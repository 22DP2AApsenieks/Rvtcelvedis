extends Node2D

@export_node_path("Control") var pause_menu_path: NodePath
@onready var pause_menu: Control = get_node_or_null(pause_menu_path)

func _ready() -> void:
	if pause_menu:
		pause_menu.visible = false
		pause_menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	else:
		push_warning("Pause menu path not set or node missing.")

func _unhandled_input(ev: InputEvent) -> void:
	if ev.is_action_pressed("ui_cancel") and pause_menu:
		if pause_menu.visible:
			pause_menu.call("close")
		else:
			pause_menu.call("open")
		get_viewport().set_input_as_handled()
