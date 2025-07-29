#############################
#	default: PROJECTILE
#	intended: using one of the setter functions, allows you to check & populate the values that are relevant
#############################
extends Node2D
class_name Attack_old

# node that a projectile would have its position tracked seperately by the engine itself (parent)
func setProjectile(_velocity: Vector2, _damage: float, # mandatory
	# optional, but commonly used
	_stun_duration: float = 0.0,
	_knockback: Vector2 = Vector2(0.0, 0.0),
	_pierce_count: int = 0,
	_bounce_count: int = 0,
	_team_allegiance: teamAllegiance = teamAllegiance.NEUTRAL,
	_damage_type: damageType = damageType.NORMAL,
	# optional, rarely used
	_source: Node2D = null,
	_trajectory_type: trajectoryType = trajectoryType.LINEAR,
	_is_explosion: bool = false,
	_does_explosion_knockback: bool = false,
	_explosion_radius: float = 1.0
) -> void:
	# ASSIGN THE VALUES
	attack_type = attackType.PROJECTILE
	
	velocity = _velocity
	damage = _damage
	stun_duration = _stun_duration
	knockback = _knockback
	pierce_count = _pierce_count
	bounce_count = _bounce_count
	team_allegiance = _team_allegiance
	damage_type = _damage_type
	source = _source
	trajectory_type = _trajectory_type
	is_explosion = _is_explosion
	does_explosion_knockback = _does_explosion_knockback
	explosion_radius = _explosion_radius

func setMelee(_damage: float, # mandatory
	# optional, commonly used
	_stun_duration: float = 0.0,
	_knockback: Vector2 = Vector2(0.0, 0.0),
	_team_allegiance: teamAllegiance = teamAllegiance.NEUTRAL,
	_damage_type: damageType = damageType.NORMAL,
	# optional, rarely used
	_source: Node2D = null,
	_is_explosion: bool = false,
	_does_explosion_knockback: bool = false,
	_explosion_radius: float = 1.0
) -> void:
	# ASSIGN THE VALUES
	attack_type = attackType.MELEE
	
	damage = _damage
	stun_duration = _stun_duration
	knockback = _knockback
	team_allegiance = _team_allegiance
	damage_type = _damage_type
	source = _source
	is_explosion = _is_explosion
	does_explosion_knockback = _does_explosion_knockback
	explosion_radius = _explosion_radius

# TODO
func setAura():
	attack_type = attackType.AURA

# ENUMERATIONS
enum attackType { # determines behavior and intended parent class of attack
	PROJECTILE, # anything that detaches from the character and moves with its own velocity
	MELEE, # non disappearing attack (infinite pierce, and a attached to the character)
	AURA # mostly intended to inflict status effects
}
enum teamAllegiance { # determines who this projectile can attack (PLAYERS allegience attacks MOBS only [maybe NEUTRAL])
	NEUTRAL,
	PLAYERS,
	MOBS
}
enum damageType { # determines how this damage is treated by the receiver (status effects, damage calculation, etc)
	NORMAL,
	TRUE
}

#for all
var attack_type: attackType = attackType.PROJECTILE
var team_allegiance: teamAllegiance = teamAllegiance.NEUTRAL
var source: Node2D = null # optional owner of this PROJECTILE (used for character passives, and checking enemy vs teammate)
var damage_type: damageType = damageType.NORMAL # eventually can have status effect type damage
var damage: float = 10.0

# for PROJECTILE
enum trajectoryType{
	LINEAR
	#tracking
}
var velocity := Vector2(1.0, 0.0) # TEMP;default shoots right for debugging
var trajectory_type: trajectoryType = trajectoryType.LINEAR
var pierce_count: int = 0 # how many enemies it can hit through
var bounce_count: int = 0 # how many times this PROJECTILE can

# for PROJECTILE and MELEE
var stun_duration := 0.0 #seconds
var knockback := Vector2(0.0,0.0)
var is_explosion: bool = false
var explosion_radius: float = 1.0
var does_explosion_knockback: bool = false
