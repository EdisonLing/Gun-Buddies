# MobBase.gd
extends CharacterBody2D
class_name MobBase

@export_group("Essential")
@export var hitbox_shape: CollisionShape2D

@export var move_speed := 160.0
@export var gravity := 1200.0
@export var stop_distance := 8.0    # how close before stopping

var target: Node2D

func _ready() -> void:
	target = get_tree().get_first_node_in_group("player") as Node2D
	if target == null:
		push_warning("No node in group 'player' found. Mob will idle.")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if target and is_instance_valid(target):
		var dx := target.global_position.x - global_position.x
		var dir : int = sign(dx)
		# stop when close enough
		if abs(dx) > stop_distance:
			velocity.x = dir * move_speed
		else:
			velocity.x = 0.0
	else:
		velocity.x = 0.0

	move_and_slide()
