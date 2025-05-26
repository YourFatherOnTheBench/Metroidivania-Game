extends CanvasLayer


@onready var _2: Parallax2D = $"2"
@onready var _3: Parallax2D = $"3"
@onready var _4: Parallax2D = $"4"

@export var player: Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player:
		if player.velocity.x > 0:
			_2.autoscroll.x = -10
			_3.autoscroll.x = -25
			_4.autoscroll.x = -60
		elif player.velocity.x < 0:
			_2.autoscroll.x = 10
			_3.autoscroll.x = 25
			_4.autoscroll.x = 60
			
		else:
			_2.autoscroll.x = 0
			_3.autoscroll.x = 0
			_4.autoscroll.x = 0
