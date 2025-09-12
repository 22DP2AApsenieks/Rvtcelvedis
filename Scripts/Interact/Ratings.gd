extends Node

const GLOBAL_FILE: String = "user://ratings_global.json"
const PERUSER_FILE: String = "ratings_user.json"   # stored inside the user's profile folder

# ---------- internals ----------
static func _current_user() -> String:
	if Engine.has_singleton("AuthService"):
		var u: String = String(AuthService.current_user())
		return u if u != "" else "guest"
	return "guest"

static func _load_global() -> Dictionary:
	return SaveLoad.load_json(GLOBAL_FILE)

static func _save_global(g: Dictionary) -> void:
	SaveLoad.save_json(GLOBAL_FILE, g)

static func _load_user() -> Dictionary:
	return SaveLoad.load_json(SaveLoad.profile_path(PERUSER_FILE))

static func _save_user(d: Dictionary) -> void:
	SaveLoad.save_json(SaveLoad.profile_path(PERUSER_FILE), d)

# ---------- public API ----------
func submit_toilet_rating(toilet_id: String, stars: int) -> Dictionary:
	# clamp stars
	stars = clampi(stars, 1, 5)
	var user: String = _current_user()

	# global file
	var g: Dictionary = _load_global()
	if not g.has("toilets"):
		g["toilets"] = {}
	var toilets: Dictionary = g["toilets"] as Dictionary

	# record for this toilet
	var t: Dictionary = (toilets.get(toilet_id, {"sum": 0, "count": 0, "by_user": {}}) as Dictionary)
	var by_user: Dictionary = (t.get("by_user", {}) as Dictionary)

	var prev: int = int(by_user.get(user, 0))
	if prev > 0:
		# user is changing their vote
		t["sum"] = int(t.get("sum", 0)) - prev + stars
		by_user[user] = stars
	else:
		# new vote
		t["sum"] = int(t.get("sum", 0)) + stars
		t["count"] = int(t.get("count", 0)) + 1
		by_user[user] = stars

	t["by_user"] = by_user
	toilets[toilet_id] = t
	g["toilets"] = toilets
	_save_global(g)

	# per-user file (optional history)
	var per: Dictionary = _load_user()
	var my_toilets: Dictionary = (per.get("toilets", {}) as Dictionary)
	my_toilets[toilet_id] = stars
	per["toilets"] = my_toilets
	_save_user(per)

	var count: int = int(t.get("count", 0))
	var avg: float = 0.0 if count == 0 else float(int(t.get("sum", 0))) / float(count)
	return {"ok": true, "avg": avg, "count": count, "yours": stars}

func get_toilet_info(toilet_id: String) -> Dictionary:
	var g: Dictionary = _load_global()
	var toilets: Dictionary = (g.get("toilets", {}) as Dictionary)
	var t: Dictionary = (toilets.get(toilet_id, {}) as Dictionary)
	if t.is_empty():
		return {"avg": 0.0, "count": 0}
	var sum_i: int = int(t.get("sum", 0))
	var count_i: int = int(t.get("count", 0))
	var avg_f: float = 0.0 if count_i == 0 else float(sum_i) / float(count_i)
	return {"avg": avg_f, "count": count_i}

static func get_user_toilet_rating(toilet_id: String) -> int:
	var per: Dictionary = _load_user()
	var my_toilets: Dictionary = (per.get("toilets", {}) as Dictionary)
	return int(my_toilets.get(toilet_id, 0))
