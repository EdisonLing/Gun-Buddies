extends ProgressBar

@export_group("Linked")
@export var health_component: HealthComponent

func _ready() -> void:
	#var sb = StyleBoxFlat.new()
	#add_theme_stylebox_override("fg", sb)
	#sb.bg_color = Color.DARK_RED
	pass

func _process(_delta: float) -> void:
	max_value = health_component.max_health
	value = health_component.current_health
