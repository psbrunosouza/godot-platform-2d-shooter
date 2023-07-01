extends CharacterBody2D

var gravity_force = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var player: Player = get_node("/root/world/player")
@onready var animation: AnimationPlayer = $animation
@onready var sprite: Sprite2D = $sprite
@onready var left_detector: RayCast2D = $left_detector
@onready var right_detector: RayCast2D = $right_detector

var speed: float = 25.0
var direction: int = -1
var knockback_vector: Vector2 = Vector2.ZERO
var hitted: bool = false
var life: int = 3

func _physics_process(delta):
	gravity(delta)
	move()
	set_direction()
	animation_machine()
	move_and_slide()

func gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity_force * delta

func set_direction() -> void:
	if left_detector.is_colliding():
		direction = 1
		sprite.flip_h = true
	elif right_detector.is_colliding():
		direction = -1
		sprite.flip_h = false

func move() -> void:
	velocity.x = speed * direction
	
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
		
func animation_machine() -> void:
	if hitted:
		animation.play("hit")
	elif velocity.x != 0:
		animation.play("run")
	

func _on_hitbox_body_entered(body) -> void:
	if body.name == "bullet":
		take_damage() 
		hitted = true
		if player.player_direction == "left":
			knockback_vector = Vector2(-100, -100)
		elif player.player_direction == "right":
			knockback_vector = Vector2(100, -100)
		
		var snakeKnockbackTween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		snakeKnockbackTween.tween_property(self, "knockback_vector", Vector2.ZERO, 0.15)

func _on_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hit":
		hitted = false
		
func take_damage() -> void:
	$audio.play()
	if life > 1:
		life -= 1
	else: 
		queue_free()
