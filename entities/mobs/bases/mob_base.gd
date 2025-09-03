# MobBase.gd
extends CharacterBody2D
class_name MobBase

@export_group("Essential")
@export var hitbox_shape: CollisionShape2D

@export var move_speed := 160.0
@export var gravity := 1200.0
@export var jump_velocity = -200
@export var stop_distance := 8.0    # how close before stopping

var target: Node2D
var stunned: bool = false
var stun_duration: float = 0.0
@onready var stun_timer:Timer = $StunTimer

func _ready() -> void:
	target = get_tree().get_first_node_in_group("player") as Node2D
	if target == null:
		print("No node in group 'player' found. Mob will idle.")
	else:
		print("Player set as target successfully")

func _physics_process(delta: float) -> void:
	stun_duration = stun_timer.time_left
	if stun_duration == 0.0:
		stunned = false
	if not is_on_floor():
		velocity.y += gravity * delta
	if !is_instance_valid(target) and is_on_floor():
		velocity.y = jump_velocity
	# Apply vertical offset if active
	knockback_z += knockback_z_velocity * delta
	if knockback_z < 0.0:
		knockback_z = 0.0

	# >>> Add this line: convert "fake pop" into real vertical velocity (up is negative)
	velocity.y -= knockback_z_velocity

	# Optional: if on floor, kill any downward pop
	if is_on_floor() and velocity.y > 0.0:
		knockback_z_velocity = 0.0

	if !stunned and target and is_instance_valid(target):
		var dx := target.global_position.x - global_position.x
		var dir : int = sign(dx)
		# stop when close enough
		if abs(dx) > stop_distance:
			velocity.x = dir * move_speed
		else:
			velocity.x = 0.0
	elif stunned:
		pass
	else:
		velocity.x = 0.0

	move_and_slide()

func stun(_incoming_stun_duration) -> void:
	print("just stunned")
	stunned = true
	if _incoming_stun_duration > stun_duration:
		stun_timer.wait_time = _incoming_stun_duration
		stun_timer.start()
	return

# Add this property to your character if not already there
var knockback_z := 0.0      # vertical offset (fake height)
var knockback_z_velocity := 0.0

func knockback(direction: Vector2, strength: float, duration: float) -> void:
	var dir = direction.normalized()
	var start_speed = strength * Globals.random_in_percentage(1, 15)
	var vertical_fraction = 0.1   # 50% of horizontal knockback strength
	var vertical_strength = strength * vertical_fraction

	stun(duration)

	# --- Horizontal knockback tween ---
	var tween := create_tween()
	tween.tween_method(func(speed):
		velocity.x = dir.x * speed     # only touch X so gravity/jumps/vertical pop stay intact
	, start_speed, 0.0, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	# --- Vertical knockback tween ---
	var tween_z := create_tween()
	tween_z.tween_method(func(z_vel):
		knockback_z_velocity = z_vel
	, vertical_strength, 0.0, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	
