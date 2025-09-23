# WaveCountdownUI.gd
extends Control

@onready var countdown_label: Label
@onready var wave_info_label: Label
var countdown_timer: float = 0.0
var is_counting_down: bool = false

var showing_start_message: bool = false

func _ready():
	setup_ui()
	# Connect to RunManager signals
	RunManager.wave_defeated.connect(_on_wave_defeated)
	
	if not RunManager.game_started:
		await get_tree().process_frame  # Wait one frame for UI to be fully set up
		show_game_starting()
		print("Showing initial game starting message")
		
func setup_ui():
	# Position at top center of screen
	anchor_left = 0.5
	anchor_right = 0.5
	anchor_top = 0.0
	anchor_bottom = 0.0
	offset_left = -150  # Half the width to center it
	offset_right = 150
	offset_top = 20
	offset_bottom = 80
	
	# Main countdown label
	countdown_label = Label.new()
	countdown_label.text = ""
	countdown_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	countdown_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	countdown_label.anchor_left = 0.0
	countdown_label.anchor_right = 1.0
	countdown_label.anchor_top = 0.0
	countdown_label.anchor_bottom = 0.7
	
	# Style the countdown text
	countdown_label.add_theme_font_size_override("font_size", 32)
	countdown_label.add_theme_color_override("font_color", Color.RED)
	
	add_child(countdown_label)
	
	# Wave info label (shows current wave, etc.)
	wave_info_label = Label.new()
	wave_info_label.text = ""
	wave_info_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	wave_info_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	wave_info_label.anchor_left = 0.0
	wave_info_label.anchor_right = 1.0
	wave_info_label.anchor_top = 0.7
	wave_info_label.anchor_bottom = 1.0
	
	# Style the wave info text
	wave_info_label.add_theme_font_size_override("font_size", 16)
	wave_info_label.add_theme_color_override("font_color", Color.WHITE)
	
	add_child(wave_info_label)
	
	
func _process(delta):
	if is_counting_down:
		countdown_timer -= delta
		
		if countdown_timer <= 0:
			# Countdown finished
			is_counting_down = false
			countdown_label.text = ""
			wave_info_label.text = ""
		else:
			# Update countdown display
			var seconds = ceil(countdown_timer)
			countdown_label.text = "Next Wave in: " + str(seconds)
			
			# Change color based on time remaining
			if seconds <= 1:
				countdown_label.add_theme_color_override("font_color", Color.RED)
			elif seconds <= 2:
				countdown_label.add_theme_color_override("font_color", Color.YELLOW)
			else:
				countdown_label.add_theme_color_override("font_color", Color.WHITE)
				
	if showing_start_message and Input.is_action_just_pressed("start wave"):
		wave_info_label.text = ""
		countdown_label.text = ""
		showing_start_message = false

func _on_wave_defeated():
	# Start countdown when wave is defeated
	start_countdown(10.0)  # Match WAVE_WAIT_TIME from spawner
	wave_info_label.text = "Wave " + str(RunManager.current_wave) + " Complete!"


func start_countdown(duration: float):
	countdown_timer = duration
	is_counting_down = true

func show_game_starting():
	# Show when game first starts
	countdown_label.text = "Game Starting!"
	countdown_label.add_theme_color_override("font_color", Color.GREEN)
	wave_info_label.text = "Press [ENTER] to begin first wave"
	showing_start_message = true
	
	
