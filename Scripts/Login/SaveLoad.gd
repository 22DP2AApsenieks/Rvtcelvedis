extends Node

func save_json(path: String, data: Variant) -> void:
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		push_error("SaveLoad: Could not open %s for write." % path)
		return
	f.store_string(JSON.stringify(data, "\t"))
	f.close()

func load_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return {}
	var txt := f.get_as_text()
	f.close()
	var d: Variant = JSON.parse_string(txt)
	return (d as Dictionary) if typeof(d) == TYPE_DICTIONARY else {}

# -------- per-user helpers (works with or without AuthService autoload) --------
func _get_user() -> String:
	if Engine.has_singleton("AuthService"):
		var u: String = String(AuthService.current_user())
		return u if u != "" else "guest"
	return "guest"

func profile_dir() -> String:
	var u := _get_user()
	return "user://profiles/%s" % u

func ensure_profile_dir() -> void:
	DirAccess.make_dir_recursive_absolute(profile_dir())

func profile_path(file_name: String) -> String:
	ensure_profile_dir()
	return "%s/%s" % [profile_dir(), file_name]
