extends CharacterBody2D
class_name Bullet

const SPEED = 139.0
const JUMP_VELOCITY = -400.0
const PROTAG_BULLET = preload("res://scenes/ProtagBullet.tscn")
const MAGAZINE_SIZE = 10

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var gun_marker: Marker2D = $Node2D/GunMarker2D 

var is_shooting = false
var is_retrieving = false
var bullets_remaining = MAGAZINE_SIZE

func _ready():
	# Connect the animation finished signal
	animated_sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _process(delta):
	# Handle shooting - bullets can be fired during both jump and ground, but only play shooting animation on the ground
	if Input.is_action_just_pressed("shoot"):
		shoot()
	elif Input.is_action_just_pressed("suck_back"):
		try_retrieve_bullet()

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

func shoot():
	# Only play shooting animation if on the ground
	if bullets_remaining <= 0:
		return
	
	if is_on_floor():
		is_shooting = true
		animated_sprite.play("shoot")

	# Create and shoot the bullet regardless of being on the ground or jumping
	var bullet = PROTAG_BULLET.instantiate()
	get_tree().get_root().add_child(bullet)
	bullet.position = gun_marker.global_position
	bullet.player = self 
	bullet.add_to_group("Bullets")
	
	# Set bullet velocity based on player facing direction
	if animated_sprite.flip_h:
		# Player is facing left
		bullet.bullet_velocity = Vector2(-1, 0)
	else:
		# Player is facing right
		bullet.bullet_velocity = Vector2(1, 0)

	bullets_remaining -= 1
	print("Bullets remaining after shoot:", bullets_remaining)
	
func try_retrieve_bullet():
	print("try_retrieve_bullet() called") 
	
	for bullet in get_tree().get_nodes_in_group("Bullets"):
		# Check if `bullet` has the `returning` property before accessing it
		if bullet.has_method("get") and bullet.get("returning") == false:
			if bullet.global_position.distance_to(global_position) < bullet.return_range:
				bullet.returning = true
				is_retrieving = true
				animated_sprite.play_backwards("shoot")
				
				bullet.queue_free()
				
				return  

				
func on_bullet_returned():
	bullets_remaining += 1
	is_shooting = false
	is_retrieving = false
	animated_sprite.play("idle")
	print("Bullets remaining after retrieval:", bullets_remaining)
	
func _on_animation_finished():
	# Reset shooting state when the shoot animation finishes
	if animated_sprite.animation == "shoot":
		if is_retrieving:
			on_bullet_returned()
		else: 
			is_shooting = false
			animated_sprite.play("idle")
