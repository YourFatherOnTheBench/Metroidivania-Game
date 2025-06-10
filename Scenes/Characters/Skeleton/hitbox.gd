extends Area2D

const dmg: int = 30


func _on_scouting_area_area_entered(area: Area2D) -> void:
	$"..".attack = true


func _on_scouting_area_area_exited(area: Area2D) -> void:
	$"..".attack = false
