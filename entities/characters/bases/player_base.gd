extends CharacterBody2D
class_name PlayerBase

@export_group("Essential")
@export var hitbox_shape: CollisionShape2D

@export_group("Stats")
@export var speed := 220.0
@export var jump_velocity := -420.0
@export var slide_speed := 300.0
@export var slide_duration := 0.8
@export var slide_friction := 0.9

@export_group("Hitbox Settings")
@export var normal_hitbox_size := Vector2(20, 40)
@export var normal_hitbox_offset := Vector2(0, 0)
@export var slide_hitbox_size := Vector2(40, 20)
@export var slide_hitbox_offset := Vector2(0, 10)

@onready var sprite = $AnimatedSprite2D
@onready var weapon_component = $WeaponComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var revolver: WeaponBase = $WeaponComponent/Revolver

var max_health = 500
var kill_count = 0
var facing_right := true

# Slide variables
var is_sliding := false
var slide_timer := 0.0
var slide_direction := 0.0

func _ready() -> void:
	add_to_group("player")
	# Set initial hitbox to normal size
	adjust_hitbox_for_normal()
	#$HealthComponent.connect("health_depleted","_on_health_depleted")
	
func _on_health_depleted():
	queue_free()

func _physics_process(delta: float) -> void:
	var dir_x := Input.get_axis("move_left", "move_right")
	
	# Handle slide input
	if Input.is_action_just_pressed("slide") and is_on_floor() and not is_sliding and abs(dir_x) > 0.1:
		print("slide")
		start_slide(dir_x)
	
	# Handle sliding
	if is_sliding:
		handle_slide(delta)
	else:
		# Normal movement
		if not is_on_floor():
			velocity += get_gravity() * delta
			
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_velocity
			
		velocity.x = dir_x * speed
	
	move_and_slide()
	_update_anim()

func start_slide(direction: float) -> void:
	is_sliding = true
	slide_timer = slide_duration
	slide_direction = direction
	velocity.x = direction * slide_speed
	# Add this line to change hitbox when sliding starts
	adjust_hitbox_for_slide()

func handle_slide(delta: float) -> void:
	slide_timer -= delta
	
	# Apply friction during slide
	velocity.x *= slide_friction
	
	# Add gravity during slide
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# End slide when timer runs out or player stops moving horizontally
	if slide_timer <= 0 or abs(velocity.x) < 150.0:
		end_slide()

func end_slide() -> void:
	is_sliding = false
	slide_timer = 0.0
	slide_direction = 0.0
	# Add this line to restore hitbox when sliding ends
	adjust_hitbox_for_normal()

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
		
func take_damage(_attack: Attack):
	print("Player taking damage: ", _attack.damage)
	health_component.takeDamage(_attack)

func _update_anim() -> void:
	if is_sliding:
		if sprite.animation != "slide":
			sprite.play("slide")
	elif is_on_floor():
		if abs(velocity.x) > 0.1:
			if sprite.animation != "run":
				sprite.play("run")
		else:
			sprite.play("idle")
	else:
		sprite.animation = "jump"

func adjust_hitbox_for_slide() -> void:
	if hitbox_shape and hitbox_shape.shape is RectangleShape2D:
		var rect_shape = hitbox_shape.shape as RectangleShape2D
		rect_shape.size = slide_hitbox_size
		hitbox_shape.position = slide_hitbox_offset

func adjust_hitbox_for_normal() -> void:
	if hitbox_shape and hitbox_shape.shape is RectangleShape2D:
		var rect_shape = hitbox_shape.shape as RectangleShape2D
		rect_shape.size = normal_hitbox_size
		hitbox_shape.position = normal_hitbox_offset
