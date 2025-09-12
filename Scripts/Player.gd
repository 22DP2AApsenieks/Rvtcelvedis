extends CharacterBody2D

@export var speed := 200.0
@export var interact_area_path: NodePath = ^"InteractArea"  # set in Inspector if needed
@onready var interact_area: Area2D = get_node_or_null(interact_area_path)

# optional: a small on-screen hint label you might be using
@export var hint_label_path: NodePath
@onready var hint_lbl: Label = get_node_or_null(hint_label_path)

func _physics_process(_delta: float) -> void:
	var dir := Vector2.ZERO
	dir.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	dir.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	velocity = dir.normalized() * speed
	move_and_slide()

	# update hint visibility if you use one
	if hint_lbl:
		var n := _nearest_interactable()
		hint_lbl.visible = n != null
		if n:
			hint_lbl.text = "E: %s" % n.prompt

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_interact"):
		var n := _nearest_interactable()
		if n:
			n.interact(self)

func _nearest_interactable() -> Interactable:
	if not $InteractArea:
		return null
	var nearest: Interactable = null
	var best := INF
	for a in $InteractArea.get_overlapping_areas():
		if a is Interactable:
			var d := global_position.distance_to(a.global_position)
			if d < best:
				best = d
				nearest = a
	return nearest
