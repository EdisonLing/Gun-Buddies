extends Path2D

#update as new mobs are implemented
const num_bosses = 0
const num_minibosses = 0
const num_strong_enemies = 0
const num_weak_enemies = 1

const WAVE_WAIT_TIME = 10.0

@export var min_spawn_distance: float = 10 #radius around player that enemies cannot spawn in
@export var player: PlayerBase

@onready var wave_timer: Timer = get_parent().get_node("WaveTimer")
@onready var countdown_ui: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RunManager.wave_defeated.connect(_on_wave_defeated_signal)
	
	# Find the countdown UI
	countdown_ui = get_node("../UI/WaveCountdownUI")
	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#start first wave logic
	if(!RunManager.game_started && Input.is_action_just_pressed("start wave")):
		RunManager.game_started = true
		spawn_wave(3)
		RunManager.start_run()
		print("game started")
	#print(RunManager.mob_count)


func _on_wave_defeated_signal():
	print("on wave defeated signal function called")
	if !wave_timer.is_stopped():
		await wave_timer.timeout
	wave_timer.start(WAVE_WAIT_TIME)
	await wave_timer.timeout
	
	# Show new wave starting
	if countdown_ui:
		countdown_ui.show_wave_starting(RunManager.current_wave + 1)

	spawn_wave()
	
func spawn_wave(optional_spawn_count: int = 0): #if -1, spawn according to score, otherwise spawn x amount of tumbleweed (only used for first wave)
	if(optional_spawn_count > 0):
		var mob_scene = load("res://entities/mobs/TumbleWeedMob.tscn")
		for i in optional_spawn_count:
			var mob_instance = mob_scene.instantiate()
			mob_instance.position = get_random_spawn_position()
			add_child(mob_instance)
			RunManager.add_mob_count(1)
	else: 
		print("spawn_wave - temp: initiate spawn wave")
		var spawn_list: Dictionary = get_mob_type_spawn_list()
		
		for mob_type in spawn_list.keys():
			var mob_count: int = spawn_list[mob_type]

			for i in mob_count:
				var mob_scene: PackedScene = helper_get_mob(mob_type)
				if mob_scene:
					var mob_instance = mob_scene.instantiate()
					mob_instance.position = get_random_spawn_position()
					add_child(mob_instance)
					RunManager.add_mob_count(1)

func helper_get_mob(mob_type: String):
	if mob_type == "Boss":
		pass #TODO return a random boss mob to spawn
	elif mob_type == "Mini Boss":
		pass #TODO return a random mini boss mob to spawn
	elif mob_type == "Strong Enemy":
		pass #TODO return a random mini boss mob to spawn
	else:
		var mob_index = randi() % num_weak_enemies
		match mob_index:
			0:
				var tumbleweed = load("res://entities/mobs/TumbleWeedMob.tscn")
				return tumbleweed
	print("helper_get_mob: defaulted to tumbleweed (unexpected)")
	return load("res://entities/mobs/TumbleWeedMob.tscn")

#chooses which mobs spawn as a function of game score
func get_mob_type_spawn_list():
	var temp_score = RunManager.score + 2
	
	var mob_spawn_dict = {"Boss": 0,
	"Mini Boss": 0,
	"Strong Enemy": 0,
	"Weak Enemy": 0
	}
	
	#spawn logic to populate dictionary
	while(temp_score >= 100 and num_bosses):
		mob_spawn_dict["Boss"] += 1
		temp_score -= 100
	while(temp_score >= 50 and num_minibosses):
		mob_spawn_dict["Mini Boss"] += 1
		temp_score -= 50
	while(temp_score >= 10 and num_strong_enemies):
		mob_spawn_dict["Strong Enemy"] += 1
		temp_score -= 10
	while(temp_score >= 1 and num_weak_enemies):
		mob_spawn_dict["Weak Enemy"] += 1
		temp_score -= 1
	if temp_score > 0:
		print("get_spawn_list: spawning logic did not use up all of score (unexpected)")
	print("Spawning: ", mob_spawn_dict)
	return mob_spawn_dict

func get_random_spawn_position() -> Vector2:
	var attempt_count: int = 0
	while(true):
		attempt_count += 1
		$PathFollow2D.progress_ratio = randf()
		if(is_instance_valid(player) and distance_between_points($PathFollow2D.global_position, player.global_position) > min_spawn_distance):
			return $PathFollow2D.global_position
		elif(!is_instance_valid(player) or attempt_count > 5): return $PathFollow2D.global_position
		else:
			print("SpawnerPath: stopped mob spawn near player")
	return $PathFollow2D.global_position

#helper
func distance_between_points(first: Vector2, second: Vector2) -> float:
	var distance = sqrt(pow((second.x - first.x), 2) + pow((second.y - first.y), 2))
	return distance
