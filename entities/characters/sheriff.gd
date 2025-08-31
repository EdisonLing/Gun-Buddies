extends PlayerBase



func _on_health_component_health_depleted() -> void:
	queue_free()
