extends Area2D
@onready var enemy: CharacterBody2D = $".."

func get_hit(dmg):
	enemy.get_hit(dmg)
	
