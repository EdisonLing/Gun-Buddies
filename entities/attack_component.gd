#############################
#	default: PROJECTILE
#	intended: using one of the setter functions, allows you to check & populate the values that are relevant
#	this is intended to go under a ProjectileBase, MeleeBase, AuraBase, or UniqueWeaponBase
#############################

extends Node2D
class_name Attack

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

var attack_type: attackType = attackType.PROJECTILE
var team_allegience: teamAllegiance = teamAllegiance.NEUTRAL
var source: Node2D = null # optional owner of this ATTACK (used for character passives, and checking enemy vs teammate)
var damage_type: damageType = damageType.NORMAL # eventually can have status effect type damage
var damage: float = 10.0

var stun_duration: float = 0.0
var direction := Vector2(1.0, 1.0) # TEMP; for use with knockback
var knockback_strength: float = 0.0
