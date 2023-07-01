class_name Player
extends CharacterBody2D

var bullet = load('res://scenes/bullet.tscn')

@onready var sprite: Sprite2D = $sprite
@onready var anim: AnimationPlayer = $animation

const SPEED: float = 150.0
const JUMP_FORCE: float = -280.0
const BULLET_DISTANCE: float = 150.0

var gravity_force: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_attacking: bool = false
var player_direction: String = "right"
var direction: float = 1;

func _physics_process(delta: float) -> void:
	gravity(delta)
	move()
	jump()
	attack()
	animation_machine()
	wayback()
	move_and_slide()

func animation_machine() -> void:
	if is_attacking:
		anim.play("attack")
	elif not is_on_floor():
		anim.play("jump")
	elif direction == 0:
		anim.play("idle")
	elif direction:
		anim.play("run")

func gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity_force * delta

func jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_FORCE

func move() -> void:
	direction = Input.get_axis("ui_left", "ui_right")
		
	set_player_direction()
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		

func set_player_direction() -> void:
	if direction < 0:
		sprite.flip_h = true
		player_direction = "left"
	elif direction > 0:
		sprite.flip_h = false
		player_direction = "right"

func get_player_direction() -> String:
	return player_direction

func attack() -> void:
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
		
		var bulletInstance = bullet.instantiate() as Bullet
		bulletInstance.position = position
		
		if get_player_direction() == "left":
			bulletInstance.position.x -= 10
		elif get_player_direction() == "right":
			bulletInstance.position.x += 10
			
		owner.add_child(bulletInstance)
	elif Input.is_action_just_released("attack"):
		is_attacking = false	

func wayback() -> void:
	if Input.is_action_just_pressed("wayback"):
		if Engine.time_scale <= 0.1:
			Engine.time_scale = 1.0
		else:
			Engine.time_scale = 0.1
