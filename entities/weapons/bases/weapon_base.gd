extends Node2D
class_name WeaponBase

signal ammo_changed(current: int, max: int)
signal reloading(started: bool)
signal fired()

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
	
	if Input.is_action_just_pressed("reload"):
		_start_reload()

func _ready() -> void:
	ammo = max_ammo if uses_ammo else 0
	emit_signal("ammo_changed", ammo, max_ammo)

func can_fire() -> bool:
	if _reloading:
		return false
	if uses_ammo and ammo <= 0:
		if auto_reload:
			_start_reload()
		else:
			# Play empty sound when out of ammo and no auto-reload
			play_empty_sound()
		return false
	if cooldown > 0.0:
		return false
	return true

func try_fire() -> void:
	# Shared gatekeeping + bookkeeping
	if !can_fire():
		return
		
	_do_fire()  # Child implements actual attack
	play_fire_sound()  # Play weapon-specific fire sound
	
	if uses_ammo:
		ammo -= 1
		emit_signal("ammo_changed", ammo, max_ammo)
		if ammo <= 0 and auto_reload:
			_start_reload()
	
	emit_signal("fired")
	cooldown = cooldown_secs

func _start_reload() -> void:
	if _reloading:
		return
		
	_reloading = true
	emit_signal("reloading", true)
	play_reload_sound()  # Play weapon-specific reload sound
	
	await get_tree().create_timer(reload_time).timeout
	
	ammo = max_ammo
	_reloading = false
	emit_signal("reloading", false)
	emit_signal("ammo_changed", ammo, max_ammo)

# --- Virtual functions for children to override ---
func _do_fire() -> void:
	# Spawn projectile / play melee swing, etc.
	# Child weapons implement this.
	pass

func play_fire_sound():
	# Override in subclasses for weapon-specific sounds
	pass

func play_reload_sound():
	# Override in subclasses for weapon-specific sounds
	pass

func play_empty_sound():
	# Override in subclasses for weapon-specific sounds
	pass
