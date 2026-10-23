extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

signal player_died
const SPEED = 50.0
var direction = -1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += direction * SPEED * delta 


func _on_timer_timeout() -> void:
	direction *= -1
	animated_sprite_2d.flip_h = (direction > 0)

func _on_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Player") or body.name == "Player") and body.alive:
		player_died.emit(body)
		
