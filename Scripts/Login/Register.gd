extends Control

@onready var auth = AuthService

# Try both common names so it works with your scene either way
@onready var _user_a: LineEdit = get_node_or_null("RegisterPanel/UsernameText")
@onready var _user_b: LineEdit = get_node_or_null("RegisterPanel/EmailText")
func _user_field() -> LineEdit:
	return _user_a if _user_a != null else _user_b

@onready var password_text: LineEdit = get_node_or_null("RegisterPanel/PasswordText")
@onready var confirm_text:  LineEdit = get_node_or_null("RegisterPanel/ConfirmText") # optional
@onready var register_btn:  Button   = get_node_or_null("RegisterPanel/RegisterButton")
@onready var cancel_btn:    Button   = get_node_or_null("RegisterPanel/CancelButton")

const MAIN_MENU_SCENE := "res://Scenes/MainMenu.tscn"
const LOGIN_SCENE     := "res://Scenes/Login.tscn"

func _ready() -> void:
	if password_text: password_text.secret = true
	if confirm_text:  confirm_text.secret = true

	# Safety: ensure required nodes exist
	if _user_field() == null:
		_toast("Username/Email field not found. Check node paths in Register.tscn.")
		return
	if password_text == null:
		_toast("Password field not found. Check node path in Register.tscn.")
		return
	if register_btn and not register_btn.pressed.is_connected(_on_register_button_pressed):
		register_btn.pressed.connect(_on_register_button_pressed)
	if cancel_btn and not cancel_btn.pressed.is_connected(_on_cancel_button_pressed):
		cancel_btn.pressed.connect(_on_cancel_button_pressed)

func _on_register_button_pressed() -> void:
	var name_edit := _user_field()
	if name_edit == null or password_text == null:
		return  # already warned in _ready()

	var u := name_edit.text.strip_edges()
	var p := password_text.text

	# Local validation so you get a friendly message instead of a crash
	if u.is_empty():
		_toast("Username cannot be empty.")
		return
	if p.is_empty():
		_toast("Password cannot be empty.")
		return
	if confirm_text and confirm_text.text != p:
		_toast("Passwords do not match.")
		return

	var res: Dictionary = auth.create_user(u, p)
	if res.ok:
		_toast("Account created. Please log in.")
		get_tree().change_scene_to_file(LOGIN_SCENE)
	else:
		_toast(res.message)

func _on_cancel_button_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)

# --- simple popup helper ---
func _toast(msg: String) -> void:
	var d := AcceptDialog.new()
	d.title = "Register"
	d.dialog_text = msg
	add_child(d)
	d.popup_centered()
	d.confirmed.connect(func(): d.queue_free())
