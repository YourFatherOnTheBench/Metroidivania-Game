extends CanvasLayer



@export var player: Node2D

@onready var vines: Parallax2D = $Vines
@onready var woods_fourth: Parallax2D = $"WOODS-fourth"
@onready var woods_third: Parallax2D = $"WOODS-THIRD"
@onready var woods_second: Parallax2D = $"WOODS-SECOND"
@onready var woods_first: Parallax2D = $"WOODS-First"



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player:
		if player.velocity.x < 0:
			woods_first.autoscroll.x = 80
			woods_second.autoscroll.x = 50
			woods_third.autoscroll.x = 25
			woods_fourth.autoscroll.x = 10
		elif player.velocity.x > 0:
			woods_first.autoscroll.x = -80
			woods_second.autoscroll.x = -50
			woods_third.autoscroll.x = -25
			woods_fourth.autoscroll.x = -10
		else:
			woods_first.autoscroll.x = 0
			woods_second.autoscroll.x = 0
			woods_third.autoscroll.x = 0
			woods_fourth.autoscroll.x = 0
