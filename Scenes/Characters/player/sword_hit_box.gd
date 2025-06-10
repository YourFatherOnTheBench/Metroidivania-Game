extends Area2D






func _on_area_entered(area: Area2D) -> void:
	area.get_hit(Globals.player_dmg)
	print("player hit enemy")
