extends MobBase
class_name MeleeMobBase

func _ready() -> void:
	super._ready()
	var melee_base = $MeleeBase
	
	if melee_base:
		melee_base.damage_dealt.connect(_on_melee_damage_dealt)

func _on_melee_damage_dealt(_target: Node2D, _source: Node2D) -> void:
	retreat(_source, _target)

func retreat(mob: MobBase, player: PlayerBase):
	var dir = (mob.global_position - player.global_position).normalized()
	
	knockback(dir, 1000, 0.2)
