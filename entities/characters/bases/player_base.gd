extends CharacterBody2D
class_name PlayerBase

@export_group("Essential")
@export var hitbox_shape: CollisionShape2D

@export_group("Stats")
@export var speed := 220.0
@export var jump_velocity := -420.0

@onready var sprite = $AnimatedSprite2D
@onready var weapon_component = $WeaponComponent
@onready var health_component = $HealthComponent
@onready var revolver: WeaponBase = $WeaponComponent/Revolver
var max_health = 500

var facing_right := true

func _ready() -> void:
	add_to_group("player")
	#$HealthComponent.connect("health_depleted","_on_health_depleted")
	
#func _on_health_depleted():
	#disable hitbox, whatever to make sure this entity is out of the match
	#do smthg (animation, death explosion, drop xp, etc.)
	#queue_free()

func _physics_process(delta: float) -> void:
	var dir_x := Input.get_axis("ui_left", "ui_right")

	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	velocity.x = dir_x * speed
	move_and_slide()

func _process(_dt: float) -> void:
	# face the mouse (right vs left), flip only the body sprite
	var mouse_global := get_global_mouse_position()
	facing_right = mouse_global.x >= global_position.x
	sprite.flip_h = not facing_right
	if facing_right:
		revolver.position.x = abs(revolver.position.x)
	else:
		revolver.position.x = abs(revolver.position.x) * -1
			

	# fire
	if Input.is_action_pressed("shoot"):
		weapon_component.try_fire()
