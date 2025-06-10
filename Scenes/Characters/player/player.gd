extends CharacterBody2D


@onready var player_animation: AnimationPlayer = $AnimationPlayer
@onready var player_sprite: Sprite2D = $Sprite2D
@onready var roll_timer: Timer = $RollTimer


var direction: Vector2 = Vector2.ZERO
enum states {RUN,DEATH, PRAY, ATTACK,ATTACK2, ATTACK3, IDLE, ROLL, CROUCH, JUMP, HURT,FALLING, HEAL}
var state = states.IDLE

var speed: float = 350
const jump_velocity: float = -550

var can_roll: bool = true
var can_jump: bool = true

var attack2: bool = false
var attack3: bool = false

const roll_speed: int = 600
var important_states = [states.PRAY, states.DEATH, states.ATTACK, states.ROLL, states.HEAL, states.ATTACK2,states.ATTACK3, states.HURT]

func _physics_process(delta: float) -> void:
	handle_input()
	handle_states(delta)
	handle_movement(delta)
	move_and_slide()



func handle_states(delta):
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
			if player_sprite.flip_h:
				velocity.x = -roll_speed
			else:
				velocity.x = roll_speed
			
			await player_animation.animation_finished
			state = states.IDLE
			roll_timer.start()
		states.HURT:
			player_animation.play("Hurt")
			velocity.x = 0
			await player_animation.animation_finished
			state = states.IDLE
		states.FALLING:
			pass
		states.ATTACK:
			$PlayerHurtBox/CollisionShape2D.disabled = false
			can_roll = true
			velocity.y = 0
			velocity.x = 0
			player_animation.play("test_attack1")
			await player_animation.animation_finished
		states.ATTACK2:
			$PlayerHurtBox/CollisionShape2D.disabled = false
			can_roll = true
			velocity.y = 0
			velocity.x = 0
			player_animation.play("test_attack2")
			await player_animation.animation_finished
		states.ATTACK3:
			$PlayerHurtBox/CollisionShape2D.disabled = false
			can_roll = true
			velocity.y = 0
			velocity.x = 0
			player_animation.play("test_attack3")
			await player_animation.animation_finished
		states.PRAY:
			velocity.x = 0
			can_roll = true
			player_animation.play("pray")
			await player_animation.animation_finished
			Globals.player_prayed()
			state = states.IDLE
		states.HEAL:
			velocity.x = 0
			player_animation.play("Heal")
			await player_animation.animation_finished
			state = states.IDLE
		states.DEATH:
			velocity.x = 0
			player_animation.play("Death")
			await player_animation.animation_finished
			print("EMIT SIGNAL DEATH")
			
func handle_input():
	if is_on_floor():
		if Input.is_action_just_pressed("jump") and can_jump and state != states.PRAY:
			handle_jump()
			state = states.JUMP
			can_jump = false
			$SwordHitBox/CollisionShape2D.disabled = true
		elif Input.is_action_just_pressed("attack"):
			if attack2:
				state = states.ATTACK2
			elif attack3:
				state = states.ATTACK3
			else:
				state = states.ATTACK
		elif Globals.can_pray and Input.is_action_just_pressed("interact"):
			state = states.PRAY
		elif Input.is_action_just_pressed("roll") and can_roll and state == states.RUN:
			state = states.ROLL
		elif Input.is_action_pressed("left") and state not in important_states:
			state = states.RUN
			$SwordHitBox/CollisionShape2D.disabled = true
			if !player_sprite.flip_h:
				player_sprite.flip_h = !player_sprite.flip_h
				$SwordHitBox.scale.x *= -1
		elif Input.is_action_pressed("right") and state not in important_states :
			state = states.RUN 
			$SwordHitBox/CollisionShape2D.disabled = true
			if player_sprite.flip_h:
				player_sprite.flip_h = !player_sprite.flip_h
				$SwordHitBox.scale.x *= -1
		elif Input.is_action_just_pressed("heal"):
			state = states.HEAL
		elif state not in important_states:
			state = states.IDLE
	elif not is_on_floor() and state == states.JUMP:
		if Input.is_action_just_pressed("attack"):
			state = states.ATTACK3
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

	if state not in important_states:
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
	$AttackComboTimer2.start()

func can_attack3():
	
	attack3 = true
	$AttackComboTimer3.start()
	
func _on_attack_combo_timer_timeout() -> void:
	attack2 = false

func F_key(value):
	var tween = get_tree().create_tween()
	tween.tween_property($"Keys/F-Key", "modulate:a", value, 0.5)
	
func _on_attack_combo_timer_3_timeout() -> void:
	attack3 = false

func get_hit(dmg):
	Globals.player_health -= dmg
	if Globals.player_health <= 0:
		state = states.DEATH
	else:
		state = states.HURT
	print("Player got hit")
	print(Globals.player_health)
