extends CharacterBody2D

const SPEED = 139.0
const JUMP_VELOCITY = -400.0
const PROTAG_BULLET = preload("res://scenes/ProtagBullet.tscn")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var marker: Marker2D = $Node2D/Marker2D

var is_shooting = false

func _ready():
	animated_sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _process(delta):
	if Input.is_action_just_pressed("shoot") and not is_shooting:
		shoot()

func _physics_process(delta: float) -> void:
	# Add gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction, -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# Flip the sprite according to direction and adjust marker position.
	if direction > 0:
		animated_sprite.flip_h = false
		marker.position.x = abs(marker.position.x)  # Ensure Marker2D is on the right side
	elif direction < 0:
		animated_sprite.flip_h = true
		marker.position.x = -abs(marker.position.x)  # Move Marker2D to the left side

	# Only play movement animations if not shooting
	if not is_shooting:
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		else:
			animated_sprite.play("jump")
	
	# Apply movement to character.
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func shoot():
	is_shooting = true
	animated_sprite.play("shoot")  # Play shooting animation

	# Create and shoot the bullet
	var bullet = PROTAG_BULLET.instantiate()
	get_parent().add_child(bullet)
	
	# Set bullet position based on current marker position
	bullet.position = marker.global_position

	# Set bullet velocity based on player facing direction
	if animated_sprite.flip_h:
		bullet.bullet_velocity = Vector2(-1, 0)  # Player facing left
	else:
		bullet.bullet_velocity = Vector2(1, 0)  # Player facing right

func _on_animation_finished():
	# Check if the shoot animation finished and reset is_shooting
	if animated_sprite.animation == "shoot":
		is_shooting = false
