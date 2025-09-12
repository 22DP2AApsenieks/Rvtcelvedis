extends Control

@onready var auth = AuthService

@onready var username_text: LineEdit   = $"LoginPanel/UsernameText"
@onready var password_text: LineEdit   = $"LoginPanel/PasswordText"
@onready var login_button:  Button     = $"LoginPanel/LoginButton"
@onready var cancel_button: Button     = $"LoginPanel/CancelButton"
@onready var remember_check: CheckButton = get_node_or_null("LoginPanel/RememberCheck")

const MAIN_MENU_SCENE := "res://Scenes/MainMenu.tscn"

func _ready() -> void:
	password_text.secret = true
	if not login_button.pressed.is_connected(_on_login_button_pressed):
		login_button.pressed.connect(_on_login_button_pressed)
	if not cancel_button.pressed.is_connected(_on_cancel_button_pressed):
		cancel_button.pressed.connect(_on_cancel_button_pressed)

func _on_login_button_pressed() -> void:
	var res: Dictionary = auth.login(username_text.text, password_text.text)
	if res.ok:
		if remember_check:
			auth.set_remember_me(remember_check.button_pressed)
		else:
			auth.set_remember_me(false)
		get_tree().change_scene_to_file(MAIN_MENU_SCENE)
	else:
		_toast(res.message)

func _on_cancel_button_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)

# --- simple popup toast ---
func _toast(msg: String) -> void:
	var d := AcceptDialog.new()
	d.title = "Login"
	d.dialog_text = msg
	add_child(d)
	d.popup_centered()
	d.confirmed.connect(func(): d.queue_free())
