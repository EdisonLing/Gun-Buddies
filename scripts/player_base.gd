extends CharacterBody2D
class_name PlayerBase

@export var speed := 220.0
@export var jump_velocity := -420.0

@onready var weapon_component = $WeaponComponent
@onready var health_component = $HealthComponent
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var dir_x := Input.get_axis("ui_left", "ui_right")

	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	velocity.x = dir_x * speed
	move_and_slide()

	if Input.is_action_pressed("shoot"):
		weapon_component.try_fire()
