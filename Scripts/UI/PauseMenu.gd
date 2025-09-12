extends Control

@onready var resume_btn: Button     = $"Panel/VBoxContainer/ResumeButton"
@onready var main_menu_btn: Button  = $"Panel/VBoxContainer/MainMenuButton"
@onready var quit_btn: Button       = $"Panel/VBoxContainer/QuitButton"

func _ready() -> void:
	# Hidden by default; still receives input while paused.
	visible = false
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	resume_btn.pressed.connect(_on_resume)
	main_menu_btn.pressed.connect(_on_main_menu)
	quit_btn.pressed.connect(_on_quit)

func open() -> void:
	visible = true
	get_tree().paused = true

func close() -> void:
	visible = false
	get_tree().paused = false

func _on_resume() -> void:
	close()

func _on_main_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _on_quit() -> void:
	get_tree().quit()
