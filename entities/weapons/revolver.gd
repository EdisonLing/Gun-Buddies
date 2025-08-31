extends WeaponBase

@export var projectile_scene: PackedScene

func _do_fire() -> void:
	# spawn projectile / play melee swing, etc.
	# child weapons implement this.
	if projectile_scene == null:
		push_warning("WeaponBase has no projectile_scene assigned.")
		return

	var p := projectile_scene.instantiate()
	p.global_position = global_position
	p.global_rotation = global_rotation
	get_tree().current_scene.add_child(p)
