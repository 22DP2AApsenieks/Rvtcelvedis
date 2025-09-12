extends Node

const DB_PATH      := "user://users.json"
const SESSION_PATH := "user://session.json"

var _db: Dictionary        = {"users": {}}
var _current_user: String  = ""
var _is_guest: bool        = false
var remember_me: bool      = false

func _ready() -> void:
	_load_db()
	_load_session()

# ─────────── Public API ───────────

func is_logged_in() -> bool:
	return _current_user != ""

func is_guest() -> bool:
	return _is_guest

func current_user() -> String:
	return _current_user

func set_remember_me(on: bool) -> void:
	remember_me = on
	_save_session()

func log_out() -> void:
	_current_user = ""
	_is_guest = false
	remember_me = false
	_save_session()

func login_guest() -> void:
	_current_user = "guest"
	_is_guest = true
	remember_me = false
	_save_session()

func create_user(username: String, password: String) -> Dictionary:
	username = username.strip_edges()
	if username.is_empty():
		return _err("Username cannot be empty.")
	if password.length() < 6:
		return _err("Password must be at least 6 characters.")
	if _db["users"].has(username):
		return _err("Username already exists.")

	var salt: PackedByteArray = Crypto.new().generate_random_bytes(16)
	var hash_b64: String = _hash_password_to_b64(password, salt)

	_db["users"][username] = {
		"salt_b64": Marshalls.raw_to_base64(salt),
		"hash_b64": hash_b64,
		"created_at": Time.get_unix_time_from_system()
	}
	_save_db()
	return _ok("User created.")

func login(username: String, password: String) -> Dictionary:
	username = username.strip_edges()
	if not _db["users"].has(username):
		return _err("Invalid username or password.")

	var user: Dictionary = _db["users"][username]
	var salt: PackedByteArray = Marshalls.base64_to_raw(String(user["salt_b64"]))
	var expected: String = String(user["hash_b64"])
	var actual: String   = _hash_password_to_b64(password, salt)
	if not _secure_equals(expected, actual):
		return _err("Invalid username or password.")

	_current_user = username
	_is_guest = false
	_save_session()  # will store user only if remember_me == true
	return _ok("Login successful.")

func change_password(username: String, old_pw: String, new_pw: String) -> Dictionary:
	username = username.strip_edges()
	if username.is_empty():
		return _err("Username required.")
	if not _db["users"].has(username):
		return _err("User not found.")
	if new_pw.length() < 6:
		return _err("Password must be at least 6 characters.")

	var user: Dictionary = _db["users"][username]
	var salt: PackedByteArray = Marshalls.base64_to_raw(String(user["salt_b64"]))
	if not _secure_equals(String(user["hash_b64"]), _hash_password_to_b64(old_pw, salt)):
		return _err("Old password incorrect.")

	var new_salt: PackedByteArray = Crypto.new().generate_random_bytes(16)
	user["salt_b64"] = Marshalls.raw_to_base64(new_salt)
	user["hash_b64"] = _hash_password_to_b64(new_pw, new_salt)
	_db["users"][username] = user
	_save_db()
	return _ok("Password changed.")

func delete_user(username: String) -> Dictionary:
	username = username.strip_edges()
	if username.is_empty():
		return _err("Username required.")
	if username == "guest":
		return _err("Cannot delete the guest account.")
	if not _db["users"].has(username):
		return _err("User not found.")

	_db["users"].erase(username)
	if _current_user == username:
		_current_user = ""
		_is_guest = false
		remember_me = false
		_save_session()
	_save_db()
	return _ok("User deleted.")

# ─────────── Internals ───────────

func _hash_password_to_b64(password: String, salt: PackedByteArray) -> String:
	var ctx := HashingContext.new()
	ctx.start(HashingContext.HASH_SHA256)
	ctx.update(password.to_utf8_buffer())
	ctx.update(salt)
	var digest: PackedByteArray = ctx.finish()
	return Marshalls.raw_to_base64(digest)

func _secure_equals(a: String, b: String) -> bool:
	var pa := a.to_utf8_buffer()
	var pb := b.to_utf8_buffer()
	if pa.size() != pb.size():
		return false
	var diff := 0
	for i in pa.size():
		diff |= pa[i] ^ pb[i]
	return diff == 0

func _load_db() -> void:
	if not FileAccess.file_exists(DB_PATH):
		_save_db()
		return
	var f := FileAccess.open(DB_PATH, FileAccess.READ)
	if f == null:
		return
	var txt: String = f.get_as_text()
	f.close()

	var parsed: Variant = JSON.parse_string(txt)
	if typeof(parsed) == TYPE_DICTIONARY:
		var dict: Dictionary = parsed
		if dict.has("users") and typeof(dict["users"]) == TYPE_DICTIONARY:
			_db = dict

func _save_db() -> void:
	var f := FileAccess.open(DB_PATH, FileAccess.WRITE)
	if f == null:
		return
	f.store_string(JSON.stringify(_db, "\t"))
	f.close()

func _save_session() -> void:
	var f := FileAccess.open(SESSION_PATH, FileAccess.WRITE)
	if f == null:
		push_error("Could not open session file for write")
		return
	var data := {
		"user": _current_user if remember_me else ""
	}
	f.store_string(JSON.stringify(data))
	f.close()

func _load_session() -> void:
	if not FileAccess.file_exists(SESSION_PATH):
		return
	var f := FileAccess.open(SESSION_PATH, FileAccess.READ)
	if f == null:
		return
	var txt: String = f.get_as_text()
	f.close()

	var v: Variant = JSON.parse_string(txt)
	if typeof(v) == TYPE_DICTIONARY:
		var d: Dictionary = v
		var u := String(d.get("user", ""))
		if u != "" and _db["users"].has(u):
			_current_user = u
			_is_guest = false

func _ok(msg: String) -> Dictionary:
	return {"ok": true, "message": msg}

func _err(msg: String) -> Dictionary:
	return {"ok": false, "message": msg}
