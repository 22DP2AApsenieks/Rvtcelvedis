class_name Interactable
extends Area2D

@export var prompt: String = "Interact"

func interact(_by: Node) -> void:
	# override in child (Toilet/Classroom)
	pass
