extends MeleeMobBase

@onready var health_component = $HealthComponent

func _ready():
	super._ready()
	stop_distance = 0.0  # always try to close the gap

func _process(delta: float) -> void:
	var attack = Attack.new()
	attack.damage = 0.2
	health_component.takeDamage(attack)





func _on_health_component_health_depleted() -> void:
	queue_free()
