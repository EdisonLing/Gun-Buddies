extends VBoxContainer

func _on_solo_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
