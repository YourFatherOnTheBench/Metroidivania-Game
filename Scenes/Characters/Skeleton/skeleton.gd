extends CharacterBody2D

var speed: int = 100
@onready var x: RayCast2D = $X
@onready var y: RayCast2D = $Y
@onready var enemy: CharacterBody2D = $"."
@onready var tree: AnimationTree = $AnimationTree
@onready var animation: AnimationPlayer = $AnimationPlayer



var attack_cooldown: bool = true
var attack: bool = false
var HP: int = 120
const dmg: int = 20

enum states {ATTACK, HURT, DEATH, WALK, IDLE, SHIELD}
var state = states.WALK
var important_states = [states.HURT, states.ATTACK, states.DEATH, states.SHIELD]
var play:bool = true
@onready var collision_shape_2d: CollisionShape2D = $Hitbox/CollisionShape2D

func _physics_process(delta: float) -> void:
	if play:
		handle_states()
		check_X_Y()
		handle_walking()
		move_and_slide()



func attacking():
	if attack and attack_cooldown:
		state = states.ATTACK


func check_X_Y():
	if x.is_colliding() or !y.is_colliding():
		speed *= -1
		self.scale.x *= -1

func handle_walking():
	if state not in important_states:
		velocity.x = speed

func handle_states():
	match state:
		states.WALK:
			animation.play("Walk")
		states.HURT:
			velocity.x = 0
			animation.play("Take_hit")
			await animation.animation_finished
			state = states.WALK
		states.ATTACK:
			animation.play("Attack1")
			await animation.animation_finished
			attack_cooldown = false
			$AttackCooldown.start()
			state = states.WALK
		states.DEATH:
			velocity.x = 0
			animation.play("Death")
			await animation.animation_finished
			play = false
			


func can_attack():
	pass

func get_hit(dmg):
	HP -= dmg
	print(HP)
	if HP <= 0:
		state = states.DEATH
	else:
		state = states.HURT
	
		


func _on_timer_timeout() -> void:
	attack_cooldown = true
