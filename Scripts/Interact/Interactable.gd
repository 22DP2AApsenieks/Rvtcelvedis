# Interactable.gd
class_name Interactable
extends Area2D

@export var prompt: String = "Press E"
func interact(_by: Node) -> void:
	# Override in children
	pass
