extends Control

func _on_login_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Login.tscn")

func _on_register_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Register.tscn")

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
