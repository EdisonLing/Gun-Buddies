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

func _update_anim() -> void:
	if is_on_floor():
		if velocity.x > 0:
			sprite.flip_h = false
			sprite.rotation += 0.2
		elif velocity.x < 0:
			sprite.flip_h = true
			sprite.rotation -= 0.2
