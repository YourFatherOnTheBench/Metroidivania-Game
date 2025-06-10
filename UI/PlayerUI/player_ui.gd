extends CanvasLayer
@onready var health_bar: TextureProgressBar = $HealthBar

func _ready() -> void:
	Globals.update_ui.connect(update)
	
	
func update():
	health_bar.value = Globals.player_health
