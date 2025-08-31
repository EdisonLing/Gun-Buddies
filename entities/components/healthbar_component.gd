extends ProgressBar

@export_group("Linked")
@export var health_component: HealthComponent

func _ready() -> void:
	#var sb = StyleBoxFlat.new()
	#add_theme_stylebox_override("fg", sb)
	#sb.bg_color = Color.DARK_RED
	pass

func _process(delta: float) -> void:
	max_value = health_component.max_health
	value = health_component.current_health
	if(health_component.current_health > 0):
		print("current_health ; max_health: ", health_component.current_health, " ; ", health_component.max_health)
		print("value ; max_value ", value, " ; ", max_value)
