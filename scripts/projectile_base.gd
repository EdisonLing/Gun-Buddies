##########
#	The idea is that the projectile base is only actually instantiated
#	when it is inactive as the child of a mob or player to hold their projectile data.
#	For active/real attacks, this is a base class that gets inherited to a real projectile
#	intended: when used as a real projectile, the projectile must have two children, one is the CollisionShape2D which will be the hitbox
#		second is a Sprite2D with a png loaded inside which will act as the projectile's texture/sprite
##########

extends Node2D
class_name ProjectileBase

@onready var attack_component = $AttackComponent

@onready var hitbox = $Area2D

@export_group("Essential")
@export var sprite: Sprite2D
@export var hitbox_shape: CollisionShape2D


func doesProjectileHit(_source: Node2D, _allegience: Attack.teamAllegiance):
	#if ((attack_component.source is Player or attack_component.source is Ally) and (attack_component.team_allegience == Attack.teamAllegiance.MOBS or attack_component.team_allegience == Attack.teamAllegiance.NEUTRAL)) or (attack_component.source is Mob and (attack_component.team_allegience == Attack.teamAllegiance.PLAYERS or attack_component.team_allegience == Attack.teamAllegiance.NEUTRAL)):
		print("Temp: function doesProjectileHit under ProjectileBase has been called, but is incomplete")
		return true

func _ready() -> void:
	if sprite:
		add_child(sprite)
		
	if hitbox_shape:
		hitbox.add_child(hitbox_shape)

func _physics_process(delta: float) -> void:
	if !active: return
	var velocity = Vector2.RIGHT.rotated(rotation) * speed
	global_position += velocity * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !active: return
	#if Node2D is Player, enemy, etc do smthg, otherwise do nothing
	if doesProjectileHit(attack_component.source, attack_component.team_allegience):
		#subtract from pierce count, or delete projectile
		pass
	pass

enum trajectoryType{
	LINEAR
	#tracking
}

@export var active: bool = true

@export_group("Behavior")
@export var speed: float = 5.0 #smthg/s
@export var trajectory_type: trajectoryType = trajectoryType.LINEAR
@export var pierce_count: int = 0 # how many enemies it can hit through
@export var bounce_count: int = 0 # how many times this PROJECTILE can

@export_group("Explosion")
@export var is_explosion: bool = false
@export var explosion_radius: float = 1.0
@export var explosion_knockback: float = 0.0
@export var explosion_stun_duration: float = 0.0
