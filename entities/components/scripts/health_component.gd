###########################
#	Prerequisite:
#		parent node MUST be the actual entity, and has the following code to connect:
#		func _ready() -> void:
#			$HealthComponent.connect("health_depleted","_on_health_depleted")
#			...
#			func _on_health_depleted():
#				disable hitbox, whatever to make sure this entity is out of the match
#				do smthg (animation, death explosion, drop xp, etc.)
#				queue_free()
###########################

extends Node2D
class_name HealthComponent

# signal that shows parent entity has died, attack is for animation & kill message
# attacker is derived from attack, and will allow you to give xp, items etc. to the killer
signal health_depleted(attacker: Node2D, attack: Attack)

@export var max_health: float = 100
var current_health: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent = get_parent()
	if "max_health" in parent:
		max_health = parent.max_health
	else:
		push_warning("Parent does not define max_health, using default from Inspector: " + str(max_health))
	current_health = max_health

func takeDamage(attack: Attack) -> void:
	var final_damage: float
	match attack.damageType:
		Attack.damageType.NORMAL:
			final_damage = attack.damage
		Attack.damageType.TRUE:
			final_damage = attack.damage
		_:
			final_damage = attack.damage
	current_health -= final_damage
	
	if current_health <= 0:
		current_health = 0
		print("emitted health_depleted signal")
		emit_signal("health_depleted")
		#AFTER THIS STEP, THE PARENT SHOULD DISAPPEAR
	
func heal(_amount) -> void:
	current_health += _amount
	current_health = min(current_health, max_health)
