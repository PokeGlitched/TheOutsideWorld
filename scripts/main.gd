extends Node2D
@onready var score_label: Label = $HUD/ScorePanel/ScoreLabel

var score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _setup_level() -> void:
	#Connect enemies
	var collectibles = $LevelRoot.get_node_or_null("Collectibles")
	if collectibles:
		for collectible in collectibles.get_children():
			collectible.collected.connect(increase_score)
	
	var enemies = $LevelRoot.get_node_or_null("Enemies")
	if enemies:
		for enemy in enemies.get_children():
			enemy.player_died.connect(_on_player_died)


# 
# Signal Handlers
#
func _on_player_died(body):
	body.die()
	print("Player killed")

#
# Score
#

func increase_score() -> void:
	score += 1
	score_label.text = "Score: %s" % score
