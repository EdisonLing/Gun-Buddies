extends Node2D
class_name WeaponBase

@export var projectile_scene: PackedScene
@export var cooldown_secs: float = 0.20

var _cooldown := 0.0

func _process(delta: float) -> void:
	if _cooldown > 0.0:
		_cooldown -= delta
	# Aim directly at the cursor
	look_at(get_global_mouse_position())

func try_fire() -> void:
	if _cooldown > 0.0:
		return
	if projectile_scene == null:
		push_warning("WeaponBase has no projectile_scene assigned.")
		return

	var p := projectile_scene.instantiate()
	p.global_position = global_position
	p.global_rotation = global_rotation
	get_tree().current_scene.add_child(p)

	_cooldown = cooldown_secs
