extends Node2D
class_name MeleeBase

@onready var attack_component: Attack = $AttackComponent


@onready var parent = get_parent()



@export_group("Essential")
#@export var sprite: Sprite2D
@export var hitbox: Area2D
@export var hitbox_shape: CollisionShape2D

@export var active: bool = true

@export_group("Extra")
@export var damage: float
@export var damage_cooldown: float

@onready var damage_timer: Timer = $DamageCooldownTimer

var on_cooldown: bool = false

func _ready() -> void:
	attack_component.damage = damage
	damage_timer.wait_time = damage_cooldown
	
	
	if hitbox and not hitbox.body_entered.is_connected(_on_area_2d_body_entered):
		hitbox.body_entered.connect(_on_area_2d_body_entered)
		print("Signal connected successfully")
	else:
		print("Signal was already connected")
		
	#if damage_timer and not damage_timer.timeout.is_connected(_on_damage_cooldown_timer_timeout):
		#damage_timer.timeout.connect(_on_damage_cooldown_timer_timeout)
		

func _physics_process(_delta: float) -> void:
	if !active: return
	if damage_timer.time_left == 0:
		on_cooldown = false
	else: on_cooldown = true
	
	if !on_cooldown:
		var overlapping_bodies = hitbox.get_overlapping_bodies()
		for body in overlapping_bodies:
			if body is PlayerBase and parent is MobBase:
				print("b")
				deal_damage_to_player(body)
			elif body is MobBase and parent is PlayerBase: print("Player has tried dealing melee damage to mob WIP -> _physics_process in melee_base.gd")

#signal player_overlapped(player: PlayerBase)

signal damage_dealt(target: Node2D, source: Node2D)
func deal_damage_to_player(body: Node2D) -> void:
	var player: PlayerBase = body
	print("took additional damage")
	damage_timer.start()
	player.take_damage(attack_component)
	damage_dealt.emit(body, parent)#body is player, parent is mob

func _on_area_2d_body_entered(body: Node2D) -> void:
	if on_cooldown == false:
		on_cooldown = true
		if body is PlayerBase and parent is MobBase:
			var player: PlayerBase = body
			deal_damage_to_player(player)
			#emit_signal("player_overlapped", body)
		elif body is MobBase and parent is PlayerBase:
			print("Player hit mob")
