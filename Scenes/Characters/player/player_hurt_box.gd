extends Area2D



@onready var player: CharacterBody2D = $".."


func _on_area_entered(area: Area2D) -> void:
	player.get_hit(area.dmg)


func _on_body_entered(body: Node2D) -> void:
	player.get_hit(body.dmg)
