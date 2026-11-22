extends CharacterBody2D

#Coco movement
@export var speed: float = 240.0
@export var gravity: float = 980.0
@export var stop_distance: float = 8.0
#Coco's super effective rugby dash
@export var dash_trigger_range: float = 160
@export var dash_speed: float = 500
@export var dash_hop_velocity: float = -120
@export var dash_duration: float = 0.323
@export var dash_cooldown: float = 1.323

var player: Node2D = null
#var settings and what-nots
var is_dashing: bool = false
var _dash_dir: float = 1.0
var _dash_timer: float = 0.0
var _cooldown_timer: float = 0.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D

func _physics_process(delta: float) -> void:
	if _cooldown_timer > 0.0:
		_cooldown_timer -= delta

	if not is_on_floor():
		velocity.y += gravity * delta

	if player == null or not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player") as Node2D
		velocity.x = move_toward(velocity.x, 0.0, speed)
		move_and_slide()
		return

	var dx: float = player.global_position.x - global_position.x
	var abs_dx: float = abs(dx)

	if is_dashing:
		_dash_timer -= delta
		velocity.x = _dash_dir * dash_speed
		if _dash_timer <= 0.0:
			is_dashing = false
	else:
		#makes Coco hop in the dash
		if is_on_floor() and _cooldown_timer <= 0.0 and abs_dx <= dash_trigger_range and abs_dx > stop_distance:
			_start_hop_dash(sign(dx))
		elif abs_dx > stop_distance:
			var dir_x: float = sign(dx)
			velocity.x = dir_x * speed
			_set_facing(dir_x)
		else:
			velocity.x = move_toward(velocity.x, 0.0, speed)

	move_and_slide()

#FuncS
func _start_hop_dash(dir_x: float) -> void:
	is_dashing = true
	_dash_dir = dir_x
	_dash_timer = dash_duration
	_cooldown_timer = dash_cooldown
	velocity.x = _dash_dir * dash_speed
	velocity.y = dash_hop_velocity
	_set_facing(_dash_dir)

func _set_facing(dir_x: float) -> void:
	if dir_x == 0.0:
		return
	if has_node("Coco_sprite"):
		$Coco_sprite.flip_h = dir_x < 0.0
