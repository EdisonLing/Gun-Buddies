extends Node2D
class_name WeaponComponent

var current_weapon: WeaponBase
var owner_actor: CharacterBody2D

func _ready() -> void:
	owner_actor = get_parent() as CharacterBody2D

# handles checking ammo, cd, etc 
func try_fire() -> void:
	if current_weapon:
		current_weapon.try_fire()
