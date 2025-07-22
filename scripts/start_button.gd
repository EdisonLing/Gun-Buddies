extends Button

func _on_pressed() -> void:
	var new_scene = load("res://scenes/game.tscn")
	get_tree().change_scene_to_packed(new_scene)
