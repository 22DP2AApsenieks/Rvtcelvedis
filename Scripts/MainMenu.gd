extends Control

@onready var auth = AuthService

@onready var play_guest_btn: Button = $"Panel/PlayGuestButton"
@onready var login_btn: Button      = $"Panel/LoginButton"
@onready var register_btn: Button   = $"Panel/RegisterButton"
@onready var play_btn: Button       = $"Panel/PlayButton"
@onready var logout_btn: Button     = $"Panel/LogoutButton"
@onready var quit_btn: Button       = $"Panel/QuitButton"
@onready var status_lbl: Label      = get_node_or_null("Panel/StatusLabel")

const GAME_SCENE     := "res://Scenes/Main.tscn"
const LOGIN_SCENE    := "res://Scenes/Login.tscn"
const REGISTER_SCENE := "res://Scenes/Register.tscn"

func _ready() -> void:
	if play_guest_btn and not play_guest_btn.pressed.is_connected(_on_play_guest):
		play_guest_btn.pressed.connect(_on_play_guest)
	if login_btn and not login_btn.pressed.is_connected(_go_login):
		login_btn.pressed.connect(_go_login)
	if register_btn and not register_btn.pressed.is_connected(_go_register):
		register_btn.pressed.connect(_go_register)
	if play_btn and not play_btn.pressed.is_connected(_on_play):
		play_btn.pressed.connect(_on_play)
	if logout_btn and not logout_btn.pressed.is_connected(_on_logout):
		logout_btn.pressed.connect(_on_logout)
	if quit_btn and not quit_btn.pressed.is_connected(_on_quit):
		quit_btn.pressed.connect(_on_quit)

	_refresh_ui()

func _refresh_ui() -> void:
	var logged: bool = auth.is_logged_in()

	if status_lbl:
		var text := "Not signed in"
		if logged:
			var suffix := " (guest)" if auth.is_guest() else ""
			text = "Signed in as: %s%s" % [auth.current_user(), suffix]
		status_lbl.text = text

	# show when NOT logged
	if play_guest_btn:  play_guest_btn.visible = not logged
	if login_btn:       login_btn.visible      = not logged
	if register_btn:    register_btn.visible   = not logged

	# show when logged
	if play_btn:        play_btn.visible       = logged
	if logout_btn:      logout_btn.visible     = logged

func _on_play_guest() -> void:
	auth.login_guest()
	get_tree().change_scene_to_file(GAME_SCENE)

func _go_login() -> void:
	get_tree().change_scene_to_file(LOGIN_SCENE)

func _go_register() -> void:
	get_tree().change_scene_to_file(REGISTER_SCENE)

func _on_play() -> void:
	get_tree().change_scene_to_file(GAME_SCENE)

func _on_logout() -> void:
	auth.log_out()
	_refresh_ui()

func _on_quit() -> void:
	get_tree().quit()
