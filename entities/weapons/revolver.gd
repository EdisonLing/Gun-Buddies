extends WeaponBase

@export var projectile_scene: PackedScene

var missed_bullet: bool = false 

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

	p.miss.connect(missed)
	
func missed() -> void:
	print("missed")
	missed_bullet = true
	
func _start_reload() -> void:
	_reloading = true
	emit_signal("reloading", true)
	if !missed_bullet and ammo == 0:
		ammo = max_ammo
		print("insta reload")
	else:
		await get_tree().create_timer(reload_time).timeout
		ammo = max_ammo
	_reloading = false
	emit_signal("reloading", false)
	emit_signal("ammo_changed", ammo, max_ammo)
	missed_bullet = false
	
