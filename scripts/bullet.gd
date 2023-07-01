class_name Bullet
extends CharacterBody2D

@onready var player: Player = get_node("/root/world/player")
@onready var initial_position: Vector2 = position

@export_range(0, 200) var max_distance: float = 150.0

var speed_force: float = 120.0
var is_already_shot: bool = false

func _physics_process(delta):
	if player.is_attacking and not is_already_shot:
		if player.get_player_direction() == "right":
			velocity.x = speed_force
		elif player.get_player_direction() == "left":
			velocity.x = -speed_force
		is_already_shot = true

	if is_on_floor() or is_on_wall() or position.distance_to(initial_position) >= max_distance:
		queue_free()

	move_and_slide()
#
#	if motion:
#		velocity = velocity.bounce(motion.get_normal())
