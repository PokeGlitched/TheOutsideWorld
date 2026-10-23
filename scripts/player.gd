extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $jumpsound
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

func _ready() -> void:
	add_to_group("Player")

const SPEED = 110.0
const ACCELERATION = 900.0
const FRICTION = 1200.0 
const JUMP_VELOCITY = -280.0
const COYOTE_TIME_MAX = 0.1
var alive = true

var coyote_timer = 0.0

func _physics_process(delta: float) -> void:
	
	if !alive:
		return
		
	# Add gravity and coyote time.
	if not is_on_floor():
		velocity += get_gravity() * delta
		coyote_timer -= delta
	else:
		coyote_timer = COYOTE_TIME_MAX
	
	# Add jump w coyote time.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or coyote_timer > 0.0:
			velocity.y = JUMP_VELOCITY
			jump_sound.play()
			coyote_timer = 0.0
	# Add different height jumps	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.4

	# Add left and right movement
	var direction := Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
		animated_sprite_2d.flip_h = (direction < 0)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		
	# Animations
	if not is_on_floor():
		animated_sprite_2d.animation = "jumping"
	elif velocity.x != 0:
		animated_sprite_2d.animation = "running"
	else:
		animated_sprite_2d.animation = "idle"
		
	move_and_slide()

func die() -> void:
	death_sound.play()
	animated_sprite_2d.animation = "dying"
	alive = false
