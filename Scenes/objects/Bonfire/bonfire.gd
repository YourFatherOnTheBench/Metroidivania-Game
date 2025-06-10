extends Area2D
class_name interactable_things




func _on_body_entered(body: Node2D) -> void:
	Globals.can_pray = true
	body.F_key(1)
	


func _on_body_exited(body: Node2D) -> void:
	Globals.can_pray = false
	body.F_key(0)
