extends Node2D
@onready var score_label: Label = $HUD/ScorePanel/ScoreLabel
@onready var fade: ColorRect = $HUD/Fade

var level: int = 1
var score: int = 0
var current_level_root: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#set up the level
	fade.modulate.a = 1.0
	current_level_root = get_node("LevelRoot")
	await _load_level(level, true, false)

#
# Level Management
#

func _load_level(level_number, first_load: bool, reset_score = true) -> void:
	#Fade Out
	if not first_load:
		await _fade(1.0)
		
	if reset_score:
		score = 0
		score_label.text = "Score: 0"
	
	if current_level_root:
		current_level_root.queue_free()
		
	#Change level
	var level_path = "res://scenes/levels/level%s.tscn" % level_number
	current_level_root = load(level_path).instantiate()
	add_child(current_level_root)
	current_level_root.name = "LevelRoot"
	_setup_level(current_level_root)
	
	#Fade In
	await _fade(0.0)
	
	
func _setup_level(level_root: Node) -> void:
	#Connect exit
	var exit = level_root.get_node_or_null("Flag/Exit")
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)
	
	#Connect enemies
	var collectibles = level_root.get_node_or_null("Collectibles")
	if collectibles:
		for collectible in collectibles.get_children():
			collectible.collected.connect(increase_score)
	
	var enemies = level_root.get_node_or_null("Enemies")
	if enemies:
		for enemy in enemies.get_children():
			enemy.player_died.connect(_on_player_died)
	

# 
# Signal Handlers
#
func _on_player_died(body):
	body.die()
	await _load_level(level, false, true)

func _on_exit_body_entered(body: Node2D) -> void:
	if body.name == "player":
		level += 1
		body.can_move = false
		await _load_level(level, false, false)
#
# Score
#

func increase_score() -> void:
	score += 1
	score_label.text = "Score: %s" % score
	
#
# Fade
#
func _fade(to_alpha: float) -> void:
	var tween := create_tween()
	tween.tween_property(fade, "modulate:a", to_alpha, 1.5)
	await tween.finished
