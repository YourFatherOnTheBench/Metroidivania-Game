extends NPC


func cut_scene():
	print("cutscenka")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and can_talk:
		cut_scene()
