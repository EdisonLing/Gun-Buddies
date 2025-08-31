extends Node2D
class_name WeaponBase

signal ammo_changed(current: int, max: int)
signal reloading(started: bool)
signal fired()  # optional

@export var uses_ammo := true
@export var max_ammo := 6
@export var reload_time := 1.8
@export var auto_reload := true
@export var cooldown_secs: float = 0.20

var cooldown := 0.0
var ammo := 0
var _reloading := false

func _process(delta: float) -> void:
	if cooldown > 0.0:
		cooldown -= delta
	# Aim directly at the cursor
	look_at(get_global_mouse_position())

func _ready() -> void:
	ammo = max_ammo if uses_ammo else 0
	emit_signal("ammo_changed", ammo, max_ammo)

func can_fire() -> bool:
	if _reloading:
		return false
	if uses_ammo and ammo <= 0:
		if auto_reload:
			_start_reload()
		return false
	if cooldown > 0.0:
		return false
	return true

func try_fire() -> void:
	# shared gatekeeping + bookkeeping
	if !can_fire():
		return

	_do_fire()  # child implements actual attack

	if uses_ammo:
		ammo -= 1
		emit_signal("ammo_changed", ammo, max_ammo)
		if ammo <= 0 and auto_reload:
			_start_reload()

	emit_signal("fired")
	cooldown = cooldown_secs

func manual_reload() -> void:
	if _reloading:
		return
	if !uses_ammo:
		return
	if ammo == max_ammo:
		return
	_start_reload()

func _start_reload() -> void:
	_reloading = true
	emit_signal("reloading", true)
	await get_tree().create_timer(reload_time).timeout
	ammo = max_ammo
	_reloading = false
	emit_signal("reloading", false)
	emit_signal("ammo_changed", ammo, max_ammo)

# --- to be overridden by children ---
func _do_fire() -> void:
	# spawn projectile / play melee swing, etc.
	# child weapons implement this.
	pass
