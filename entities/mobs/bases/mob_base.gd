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

func knockback(direction: Vector2, strength: float, duration: float) -> void:
	var dir = direction.normalized()
	
	velocity = dir * strength
	stun(duration)
	
