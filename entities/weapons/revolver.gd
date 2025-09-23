extends WeaponBase

# Audio nodes specific to revolver
@onready var fire_audio: AudioStreamPlayer2D = $FireAudio
@onready var reload_audio: AudioStreamPlayer2D = $ReloadAudio
@onready var empty_audio: AudioStreamPlayer2D = $EmptyAudio
@onready var instant_reload_audio: AudioStreamPlayer2D = $InstantReload

# Revolver-specific audio
@export_group("Audio")
@export var revolver_fire_sound: AudioStream
@export var cylinder_reload_sound: AudioStream
@export var empty_click_sound: AudioStream
@export var instant_reload_sound: AudioStream

# Revolver mechanics
@export_group("Projectile")
@export var projectile_scene: PackedScene

# Revolver-specific variables
var missed_bullet: bool = false

func can_fire() -> bool:
	if _reloading:
		return false
	if uses_ammo and ammo <= 0:
		if auto_reload or !missed_bullet:
			_start_reload()
		else:
			# Play empty sound when out of ammo and no auto-reload
			play_empty_sound()
		return false
	if cooldown > 0.0:
		return false
	return true
	
func _do_fire() -> void:
	if projectile_scene == null:
		push_warning("Revolver has no projectile_scene assigned.")
		return
		
	var projectile := projectile_scene.instantiate()
	projectile.global_position = global_position
	projectile.global_rotation = global_rotation
	get_tree().current_scene.add_child(projectile)
	
	# Connect to miss signal if it exists
	if projectile.has_signal("miss"):
		projectile.miss.connect(_on_projectile_missed)

func _on_projectile_missed() -> void:
	print("Revolver shot missed")
	missed_bullet = true

func _start_reload() -> void:
	if _reloading:
		return
		
	_reloading = true
	emit_signal("reloading", true)
	
	# Special revolver reload logic: instant reload if didn't miss and ammo is 0
	if !missed_bullet and ammo == 0:
		print("Perfect reload - instant!")
		play_instant_reload_sound()
		ammo = max_ammo
		_reloading = false
		emit_signal("reloading", false)
		emit_signal("ammo_changed", ammo, max_ammo)
		missed_bullet = false
		return
	
	# Normal reload with timer
	play_reload_sound()
	await get_tree().create_timer(reload_time).timeout
	
	ammo = max_ammo
	_reloading = false
	emit_signal("reloading", false)
	emit_signal("ammo_changed", ammo, max_ammo)
	missed_bullet = false

# Audio implementation
func play_fire_sound():
	print("play_fire_sound() called")
	print("revolver_fire_sound: ", revolver_fire_sound)
	print("fire_audio: ", fire_audio)
	
	if revolver_fire_sound and fire_audio:
		fire_audio.stream = revolver_fire_sound
		fire_audio.pitch_scale = randf_range(0.9, 1.1)  # Slight variation
		fire_audio.play()
		print("Fire sound should be playing")
	else:
		print("Missing fire sound or audio node!")

func play_reload_sound():
	print("play_reload_sound() called")
	if cylinder_reload_sound and reload_audio:
		reload_audio.stream = cylinder_reload_sound
		reload_audio.pitch_scale = randf_range(0.95, 1.05)  # Less variation for reload
		reload_audio.play()
		print("Reload sound should be playing")
	else:
		print("Missing reload sound or audio node!")

func play_empty_sound():
	print("play_empty_sound() called")
	if empty_click_sound and empty_audio:
		empty_audio.stream = empty_click_sound
		empty_audio.pitch_scale = randf_range(0.8, 1.2)  # More variation for clicks
		empty_audio.play()
		print("Empty sound should be playing")
	else:
		print("Missing empty sound or audio node!")
		
func play_instant_reload_sound():
	print("play_insant_reload_sound() called")
	if instant_reload_sound and instant_reload_audio:
		instant_reload_audio.stream = instant_reload_sound
		instant_reload_audio.pitch_scale = randf_range(0.95, 1.05)  # Less variation for reload
		instant_reload_audio.play()
		print("Insant reload sound should be playing")
	else:
		print("Missing reload sound or audio node!")
