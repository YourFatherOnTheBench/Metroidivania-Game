extends CanvasLayer
@export var player: Node2D

@onready var mountains: Parallax2D = $Mountains
@onready var ruins: Parallax2D = $Ruins


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player:
		if player.velocity.x < 0:
			mountains.autoscroll.x = 20
			ruins.autoscroll.x = 60

		elif player.velocity.x > 0:
			mountains.autoscroll.x = -20
			ruins.autoscroll.x = -60

		else:
			mountains.autoscroll.x = 0
			ruins.autoscroll.x = 0
