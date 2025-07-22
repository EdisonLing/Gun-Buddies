extends Node2D
class_name Attack
#determines default behaviors of attack
enum attackType{
	projectile, #anything that detaches from the character and moves with its own velocity
	melee, #non disappearing attack (infinite pierce, and a attached to the character)
	aura #mostly intended to inflict status effects
}
var attack_type: attackType = attackType.projectile

#for all
var damage: float = 10.0
var is_true_damage := false

#for projectile
enum tragectoryType{
	linear
}
var tragectory_type: tragectoryType = tragectoryType.linear
var pierce_count := 1 #how many enemies it can hit through
var velocity := Vector2(1.0, 0.0)# TEMP;default shoots right for debugging

#for projectile and melee
var is_explosion: bool
var explosion_radius: float

var stun_duration := 0.0 #seconds
var knockback := Vector2(0.0,0.0)
