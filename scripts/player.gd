extends CharacterBody2D
class_name Player

@export var SPEED := 139.0
@export var JUMP_VELOCITY := -400.0
@export var GRAVITY := 1000.0
@export var PROTAG_BULLET = preload("res://scenes/ProtagBullet.tscn")
@export var MAGAZINE_SIZE := 10

@onready var manager: Node = %Manager
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var gun_marker: Marker2D = $Node2D/GunMarker2D
@onready var state_machine: StateMachine = $StateMachine

var is_shooting = false
var is_retrieving = false
var bullets_remaining = MAGAZINE_SIZE
const RESPAWN_POSITION = Vector2(30, -50)

func _ready():
	animated_sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))
	print("Player initialized and ready.")
	
func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_retrieving:
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction, -1, 0, 1
		var direction := Input.get_axis("move_left", "move_right")
		
		# Flip the sprite according to direction and adjust marker position
		if direction > 0:
			animated_sprite.flip_h = false
			gun_marker.position.x = abs(gun_marker.position.x)  # Ensure GunMarker2D is on the right side
		elif direction < 0:
			animated_sprite.flip_h = true
			gun_marker.position.x = -abs(gun_marker.position.x)  # Move GunMarker2D to the left side

		# Animations - Only play idle or running if not shooting
		if not is_shooting:
			if is_on_floor():
				if direction == 0:
					animated_sprite.play("idle")
				else:
					animated_sprite.play("run")
			else:
				animated_sprite.play("jump")
		
		# Apply movement to character
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if state_machine:
		state_machine._physics_process(delta)

func _on_animation_finished():
	if animated_sprite.animation == "shoot":
		if is_retrieving:
			# Finish retrieving after animation
			is_retrieving = false
			state_machine.emit_signal("finished", "IdleState")
		elif is_shooting:
			# Finish shooting after animation
			is_shooting = false

func die() -> void:
	print("Player has died! Playing death animation...")
	animated_sprite.play("death")

	manager.lose_life()
	if manager.player_lives > 0:
		_respawn()
	else:
		manager.show_game_over()
		
func _respawn():
	print("Respawning player...")
	global_position = RESPAWN_POSITION
	velocity = Vector2.ZERO
