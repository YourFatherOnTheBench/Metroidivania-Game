extends Node
class_name NPC
var can_talk: bool = false





func _on_body_entered(body: Node2D) -> void:
	body.F_key(1)
	can_talk = true



	


func _on_body_exited(body: Node2D) -> void:
	body.F_key(0)
	can_talk = false
