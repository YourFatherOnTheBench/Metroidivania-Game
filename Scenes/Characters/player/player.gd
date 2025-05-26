extends CharacterBody2D


@onready var player_animation: AnimationPlayer = $AnimationPlayer
@onready var player_sprite: Sprite2D = $Sprite2D
@onready var roll_timer: Timer = $RollTimer


var direction: Vector2 = Vector2.ZERO
enum states {RUN,DEATH, PRAY, ATTACK, IDLE, ROLL, CROUCH, JUMP, HURT,FALLING, ATTACK2}
var state = states.IDLE

var speed: float = 450
const jump_velocity: float = -550

var can_roll: bool = true
var can_jump: bool = true

var attack2: bool = false
var attack3: bool = false



func _ready() -> void:
	pass
	

func _physics_process(delta: float) -> void:
	handle_input()
	handle_states()
	handle_movement(delta)
	move_and_slide()
	print(state)



func handle_states():
	match state:
		states.JUMP:
			player_animation.play("jump")
			$JumpTimer.start()
			can_roll = true
		states.RUN:
			player_animation.play("Run")
		states.IDLE:
			player_animation.play("idle")
		states.ROLL:
			can_roll = false
			
			player_animation.play("roll")
			await player_animation.animation_finished
			state = states.IDLE
			roll_timer.start()
		states.HURT:
			pass
		states.FALLING:
			pass
		states.ATTACK:
			$PlayerHurtBox/CollisionShape2D.disabled = false
			can_roll = true
			velocity.x = 0
			player_animation.play("test_attack1")
			#else:
			#	player_animation.play("test_attack2")
		states.ATTACK2:
			$PlayerHurtBox/CollisionShape2D.disabled = false
			can_roll = true
			velocity.x = 0
			


			
func handle_input():
	if is_on_floor():
		if Input.is_action_just_pressed("jump") and can_jump:
			handle_jump()
			state = states.JUMP
			can_jump = false
			$SwordHitBox/CollisionShape2D.disabled = true
		elif Input.is_action_just_pressed("attack"):
			state = states.ATTACK
		
		elif Input.is_action_just_pressed("roll") and can_roll and state == states.RUN:
			state = states.ROLL
		elif Input.is_action_pressed("left") and state != states.ROLL and state != states.ATTACK:
			state = states.RUN
			$SwordHitBox/CollisionShape2D.disabled = true
			if !player_sprite.flip_h:
				player_sprite.flip_h = !player_sprite.flip_h
				$SwordHitBox.scale.x *= -1
		elif Input.is_action_pressed("right") and state != states.ROLL and state != states.ATTACK :
			state = states.RUN 
			$SwordHitBox/CollisionShape2D.disabled = true
			if player_sprite.flip_h:
				player_sprite.flip_h = !player_sprite.flip_h
				$SwordHitBox.scale.x *= -1
		
		elif state != states.ROLL and state != states.ATTACK:
			state = states.IDLE
	elif not is_on_floor() and state == states.JUMP:
		if Input.is_action_just_pressed("attack"):
			state = states.ATTACK
		elif Input.is_action_pressed("left"):
			if !player_sprite.flip_h:
				player_sprite.flip_h = !player_sprite.flip_h
				$SwordHitBox.scale.x *= -1
		elif Input.is_action_pressed("right"):
			if player_sprite.flip_h:
				player_sprite.flip_h = !player_sprite.flip_h
				$SwordHitBox.scale.x *= -1
		
	
func handle_movement(delta):
	var dir = 0
	if Input.is_action_pressed("left"):
		dir = -1
	elif Input.is_action_pressed("right"):
		dir = 1
	#var dir := Input.get_axis("left", "right")

	if state != states.ROLL and state != states.ATTACK:
		velocity.x = dir * speed
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.2
	
	
func handle_jump():
	velocity.y = jump_velocity 




func _on_roll_timer_timeout() -> void:
	can_roll = true


func _on_jump_timer_timeout() -> void:
	can_jump = true
	
func after_attack():
	state = states.IDLE
	
func can_attack2():
	attack2 = true	
	$AttackComboTimer.start()

func can_attack3():
	attack3 = true
	
func _on_attack_combo_timer_timeout() -> void:
	attack2 = false
