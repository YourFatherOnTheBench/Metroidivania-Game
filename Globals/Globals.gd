extends Node

var player_health: int = 200:
	get:
		return player_health
	set(value):
		player_health = value
		update_ui.emit()
		
var player_dmg: int = 40
var potion_heal: int = 70
var can_pray: bool = false
var Number_Of_Potions: int = 2
var Current_number_of_potions: int = 2


signal update_ui


func player_prayed():
	print("player prayed")
