########################
#	Prerequisite:
#		1. has a custom hitbox (Area2D) placed as the child of the instance
#		2. has a HealthComponent placed under it's parent (same level)
########################
extends Area2D
class_name HitboxComponent

@export var health_component: HealthComponent

func damage(attack: Attack):
	if health_component:
		health_component.takeDamage(attack)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
