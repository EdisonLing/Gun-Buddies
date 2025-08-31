extends MeleeMobBase

@onready var health_component = $HealthComponent
var max_health = 50

func _ready():
	super._ready()
	stop_distance = 0.0  # always try to close the gap

func _process(_delta: float) -> void:
	pass





func _on_health_component_health_depleted() -> void:
	queue_free()
