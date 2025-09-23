extends Node
signal run_started(seed:int)
signal run_ended(victory:bool, score:int)
signal score_changed(score:int)
signal combo_changed(combo:int)
signal time_changed(seconds:int)
signal wave_defeated()

var seed:int
var rng := RandomNumberGenerator.new() # each run should have unique paths
var score:int = 0
var wave: int = 0
var mob_count: int = 0
var combo:int = 0
var seconds:int = 0
var game_started:bool = false
var _tick := 0.0
var current_wave: int = 1

func start_run(new_seed:int = Time.get_unix_time_from_system()) -> void:
	seed = new_seed
	rng.seed = seed
	score = 0; combo = 0; seconds = 0; _tick = 0.0
	emit_signal("run_started", seed)
	set_process(true)

func end_run() -> void:
	set_process(false)
	emit_signal("run_ended", score)

func _process(delta:float) -> void:
	_tick += delta
	if _tick >= 1.0:
		_tick -= 1.0
		seconds += 1
		emit_signal("time_changed", seconds)

func add_score(amount:int) -> void:
	score += amount
	print(score)
	emit_signal("score_changed", score)
	

func add_combo(inc:int = 1) -> void:
	combo = max(combo + inc, 0)
	emit_signal("combo_changed", combo)

func reset_combo() -> void:
	combo = 0
	emit_signal("combo_changed", combo)
	
func add_mob_count(amount:int) -> void:
	mob_count += amount
	
func reduce_mob_count(amount:int) -> void:
	if(mob_count >= amount):
		mob_count -= amount
	else:
		mob_count = 0
	if mob_count == 0:
		emit_signal("wave_defeated")
		current_wave += 1
		print("emitted wave defeated signal")
