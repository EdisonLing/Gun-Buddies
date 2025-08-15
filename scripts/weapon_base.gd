# WeaponBase.gd
extends Node2D
class_name WeaponBase

signal fired(projectile: Node2D)
signal reloaded()

# ---------- Essentials ----------
@export var projectile_scene: PackedScene                 # res://projectiles/ProjectileBase.tscn
@export var fire_rate: float = 5.0                        # shots / second
@export var auto_fire: bool = false                       # hold to fire
@export var muzzle_path: NodePath = ^"Muzzle"             # Marker2D
@export var attack_component_path: NodePath = ^"AttackComponent"

# ---------- Ammo / Reload ----------
@export var uses_ammo: bool = false
@export var ammo_max: int = 12
@export var reload_time: float = 1.2                      # seconds

var _ammo: int
var _cooldown := 0.0
var _reloading := false

var _owner: Node2D
@onready var muzzle: Marker2D = get_node_or_null(muzzle_path)
@onready var attack_component: Attack = get_node_or_null(attack_component_path)

func initialize(owner_actor: Node2D) -> void:
	_owner = owner_actor
	_ammo = ammo_max
	if attack_component:
		attack_component.source = _owner
	# Example: set team once here (adjust to your game’s team system)
	# attack_component.team_allegience = Attack.teamAllegiance.PLAYERS

func _process(delta: float) -> void:
	if _cooldown > 0.0:
		_cooldown -= delta

# Call this from WeaponComponent
func try_fire() -> void:
	# If you’re doing multiplayer, gate here:
	# if !is_multiplayer_authority(): return
	if _reloading: return
	if not can_fire(): return
	_fire_once()

func can_fire() -> bool:
	if projectile_scene == null: return false
	if muzzle == null: return false
	if attack_component == null: return false
	if _cooldown > 0.0: return false
	if uses_ammo and _ammo <= 0:
		_start_reload()
		return false
	return true

func _fire_once() -> void:
	_cooldown = 1.0 / max(fire_rate, 0.001)
	if uses_ammo:
		_ammo -= 1
	_spawn_projectile()
	emit_signal("fired", self)

func _spawn_projectile() -> void:
	var p := projectile_scene.instantiate()
	# Expecting ProjectileBase with apply_attack_from(Attack)
	if p.has_method("apply_attack_from") and attack_component:
		p.apply_attack_from(attack_component)

	# Place & orient at muzzle
	p.global_position = muzzle.global_position
	p.rotation = get_fire_rotation()

	# Add to the world (top-level scene)
	get_tree().current_scene.add_child(p)

func get_fire_rotation() -> float:
	# Default: use muzzle’s rotation. Override in child classes if you want custom aiming.
	return muzzle.global_rotation

# ---------- Ammo/Reload helpers ----------
func _start_reload() -> void:
	if not uses_ammo or _reloading: return
	_reloading = true
	# Simple timer-based reload
	var t := get_tree().create_timer(reload_time)
	t.timeout.connect(_end_reload)

func _end_reload() -> void:
	_ammo = ammo_max
	_reloading = false
	emit_signal("reloaded")

# ---------- Utility you can call from outside ----------
func is_reloading() -> bool:
	return _reloading

func ammo() -> int:
	return _ammo
