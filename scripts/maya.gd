extends CharacterBody2D

@export var move_speed: float = 220.0
@export var jump_velocity: float = -420.0
@export var gravity: float = 980.0

#dash thingys (idk if thingys is written like that or thingies)
@export var dash_speed: float = 700.0
@export var dash_duration: float = 0.3
@export var dash_cooldown: float = 1

#stuff i dont care enough about to write in detail
var facing_dir: float = 1.0
var is_dashing: bool = false
var _dash_timer: float = 0.0
var _cooldown_timer: float = 0.0

const SPEED = 300.0
const JUMP_VELOCITY = -250.0


func _physics_process(delta: float) -> void:
	#dash
	if _cooldown_timer > 0.0:
		_cooldown_timer -= delta
	
	var input_dir: float = Input.get_axis("ui_left", "ui_right")
	if input_dir != 0.0:
		facing_dir = sign(input_dir)
	if Input.is_action_just_pressed("dash") and not is_dashing and _cooldown_timer <= 0.0:
		_start_dash(input_dir)
	if is_dashing:
		_dash_timer -= delta
		velocity.x = facing_dir * dash_speed
		velocity.y = 0.0
		if _dash_timer <= 0.0:
			is_dashing = false
			velocity.x = facing_dir * move_speed
	#all other movement on an else statement so that it doesnt interfere with the dash speed
	else:
			# Add the gravity.
			if not is_on_floor():
				velocity += get_gravity() * delta

			# Handle jump.
			if Input.is_action_just_pressed("ui_accept") and is_on_floor():
				velocity.y = JUMP_VELOCITY

			# Get the input direction and handle the movement/deceleration.
			# As good practice, you should replace UI actions with custom gameplay actions.
			var direction := Input.get_axis("ui_left", "ui_right")
			if direction:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

#fUNCs
func _start_dash(input_dir: float) -> void:
	is_dashing = true
	_dash_timer = dash_duration
	_cooldown_timer = dash_cooldown
	if input_dir != 0.0:
		facing_dir = sign(input_dir)
