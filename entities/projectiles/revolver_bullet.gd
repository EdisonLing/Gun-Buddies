extends ProjectileBase

signal miss()

func doesProjectileHit(_source: Node2D, _allegience: Attack.teamAllegiance, _body_entered: Node2D):
	#if ((attack_component.source is Player or attack_component.source is Ally) and (attack_component.team_allegience == Attack.teamAllegiance.MOBS or attack_component.team_allegience == Attack.teamAllegiance.NEUTRAL)) or (attack_component.source is Mob and (attack_component.team_allegience == Attack.teamAllegiance.PLAYERS or attack_component.team_allegience == Attack.teamAllegiance.NEUTRAL)):
		if _body_entered is TileMapLayer:
			emit_signal("miss")
			return true
		elif _body_entered is MobBase and _allegience == Attack.teamAllegiance.PLAYERS:
			print("Temp: function doesProjectileHit under ProjectileBase has been called, but is incomplete. Must add allegience detection")
			return true
		elif _body_entered is PlayerBase and _allegience == Attack.teamAllegiance.MOBS:
			return true
		else: return false
