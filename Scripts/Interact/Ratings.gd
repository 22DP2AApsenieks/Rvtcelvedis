extends Node

# One shared location for ALL users (aggregates stack here)
const SHARED_DIR   := "user://shared"
const GLOBAL_FILE  := SHARED_DIR + "/ratings_global.json"

# Each user also gets their own file so we can remember their last vote
const PERUSER_FILE := "ratings_user.json"

# ---------- helpers ----------
static func _current_user() -> String:
	var u := "guest"
	if Engine.has_singleton("AuthService"):
		u = String(AuthService.current_user())
	if u == "":
		u = "guest"
	return u

static func _ensure_shared_dir() -> void:
	DirAccess.make_dir_recursive_absolute(SHARED_DIR)

static func _load_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return {}
	var txt := f.get_as_text()
	f.close()
	var d: Variant = JSON.parse_string(txt)
	return d if typeof(d) == TYPE_DICTIONARY else {}


static func _save_json(path: String, data: Dictionary) -> void:
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		push_error("Ratings: couldn't open %s for write" % path)
		return
	f.store_string(JSON.stringify(data, "\t"))
	f.close()

static func _load_global() -> Dictionary:
	return _load_json(GLOBAL_FILE)

static func _save_global(g: Dictionary) -> void:
	_ensure_shared_dir()
	_save_json(GLOBAL_FILE, g)

static func _profile_dir() -> String:
	return "user://profiles/%s" % _current_user()

static func _ensure_profile_dir() -> void:
	DirAccess.make_dir_recursive_absolute(_profile_dir())

static func _user_file() -> String:
	return "%s/%s" % [_profile_dir(), PERUSER_FILE]

static func _load_user() -> Dictionary:
	return _load_json(_user_file())

static func _save_user(d: Dictionary) -> void:
	_ensure_profile_dir()
	_save_json(_user_file(), d)

# ---------- Public API ----------

# Add/update a vote and return new summary
static func submit_toilet_rating(toilet_id: String, stars: int) -> Dictionary:
	stars = clamp(stars, 1, 5)
	var user := _current_user()

	var g := _load_global()
	var toilets: Dictionary = g.get("toilets", {})
	var t: Dictionary = toilets.get(toilet_id, {"sum": 0, "count": 0, "by_user": {}})

	var by_user: Dictionary = t.get("by_user", {})
	var prev: int = int(by_user.get(user, 0))

	if prev > 0:
		# update existing vote
		t["sum"] = int(t.get("sum", 0)) - prev + stars
		by_user[user] = stars
		t["by_user"] = by_user
	else:
		# first time voting
		t["sum"] = int(t.get("sum", 0)) + stars
		t["count"] = int(t.get("count", 0)) + 1
		by_user[user] = stars
		t["by_user"] = by_user

	toilets[toilet_id] = t
	g["toilets"] = toilets
	_save_global(g)

	# also store in user's personal history (optional)
	var u := _load_user()
	var my: Dictionary = u.get("votes", {})
	my[toilet_id] = stars
	u["votes"] = my
	_save_user(u)

	var sum := int(t.get("sum", 0))
	var count := int(t.get("count", 0))
	var avg := 0.0 if count == 0 else float(sum) / float(count)
	return {"ok": true, "avg": avg, "count": count, "yours": stars}

# Read-only info for UI labels, etc.
static func get_toilet_info(toilet_id: String) -> Dictionary:
	var g := _load_global()
	var t: Dictionary = (g.get("toilets", {}) as Dictionary).get(toilet_id, {}) as Dictionary
	var sum := int(t.get("sum", 0))
	var count := int(t.get("count", 0))
	var avg := 0.0 if count == 0 else float(sum) / float(count)
	return {"avg": avg, "count": count}
