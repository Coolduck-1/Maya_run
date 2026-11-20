extends CharacterBody2D
@export var speed: float = 90.0
@export var gravity: float = 980
@export var stop_distance: float = 8.0

var player: Node2D = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if player == null or not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player") as Node2D
		velocity.x = move_toward(velocity.x, 0.0, speed)
		move_and_slide()
		return
	
	var dx: float = player.global_position.x - global_position.x
	if abs(dx) > stop_distance:
		var dir_x: float = sign(dx)
		velocity.x = dir_x * speed
		# Optional: flip sprite to face the player
		if has_node("AnimatedSprite2D"):
			$AnimatedSprite2D.flip_h = dir_x < 0.0
		elif has_node("Sprite2D"):
			$Sprite2D.flip_h = dir_x < 0.0
	else:
		velocity.x = move_toward(velocity.x, 0.0, speed)

	move_and_slide()
