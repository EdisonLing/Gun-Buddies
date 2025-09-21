# RevolverAmmoUI.gd
# system just works for revolver, in the future will probably have to make this more dynamic
# can implement a base class for ammo ui with a manager to determine which weapon is active
extends Control

@export var bullet_radius := 6.0
@export var bullet_size := Vector2(3, 3)
@export var empty_color := Color.BLACK
@export var loaded_color := Color.GRAY
@export var offset_above_player := Vector2(0, -27)

var player: CharacterBody2D
var bullet_rects: Array[ColorRect] = []
var current_bullets := 6
var max_bullets := 6

func _ready():
	print("RevolverAmmoUI _ready() called")
	
	# Find the player - adjust path based on your scene structure
	# If structure is: Main/Player and Main/UI/RevolverAmmoUI
	player = get_node("../../Sheriff")
	print("Found player: ", player)
	
	create_bullet_display()
	connect_to_weapon()

func create_bullet_display():
	print("Creating bullet display...")
	for i in range(max_bullets):
		var bullet = ColorRect.new()
		bullet.size = bullet_size
		bullet.color = loaded_color
		
		# Position in circle (starting from top)
		var angle = (i * PI * 2.0 / max_bullets) - PI/2
		var pos = Vector2(
			cos(angle) * bullet_radius,
			sin(angle) * bullet_radius
		)
		bullet.position = pos - bullet_size / 2
		
		add_child(bullet)
		bullet_rects.append(bullet)
		print("Created bullet ", i, " at position ", bullet.position)
	
	print("Total bullets created: ", bullet_rects.size())

func connect_to_weapon():
	print("Attempting to connect to weapon...")
	if player:
		print("Player found, looking for WeaponComponent...")
		if player.has_node("WeaponComponent"):
			var weapon_component = player.get_node("WeaponComponent")
			print("WeaponComponent found: ", weapon_component)
			# Connect to weapon signals (adjust based on your weapon structure)
			if weapon_component.has_node("Revolver"):
				var revolver = weapon_component.get_node("Revolver")
				print("Revolver found: ", revolver)
				if revolver.has_signal("ammo_changed"):
					revolver.connect("ammo_changed", _on_ammo_changed)
					print("Connected to ammo_changed signal")
				else:
					print("Revolver doesn't have ammo_changed signal")
			else:
				print("No Revolver node found in WeaponComponent")
		else:
			print("No WeaponComponent found on player")
	else:
		print("Player not found!")

func _process(_delta):
	if player:
		# Follow player
		global_position = player.global_position + offset_above_player
		# Debug: print position occasionally
		if Engine.get_process_frames() % 60 == 0:  # Every second
			print("UI position: ", global_position, " Player position: ", player.global_position)

func _on_ammo_changed(current: int, max: int):
	current_bullets = current
	max_bullets = max
	update_display()

func update_display():
	for i in range(bullet_rects.size()):
		if i < current_bullets:
			bullet_rects[i].color = loaded_color
			bullet_rects[i].modulate.a = 1.0
		else:
			bullet_rects[i].color = empty_color
			bullet_rects[i].modulate.a = 0.6

# Manual update function (if you don't use signals)
func set_ammo(current: int, max: int = 6):
	current_bullets = current
	max_bullets = max
	update_display()
