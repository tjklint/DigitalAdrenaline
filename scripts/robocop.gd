extends Enemy
class_name Robocop

const BULLET = preload("res://scenes/ProtagBullet.tscn")  # Preload bullet scene

@export var bullet_color: Color = Color(1, 0, 0)  # Red color for enemy bullets
@onready var gun_marker: Node2D = $GunMarker  # Position to spawn bullets from

func _ready():
	# Set the patrol position to the starting position
	start_position = global_position
	set_physics_process(true)

func _physics_process(delta):
	# Patrol left and right
	patrol(delta)

	# Handle shooting based on cooldown
	time_since_last_shot += delta
	if time_since_last_shot >= shooting_cooldown:
		shoot()
		time_since_last_shot = 0.0

func shoot():
	# Instantiate a bullet
	var bullet = BULLET.instantiate()
	get_tree().get_root().add_child(bullet)
	bullet.position = gun_marker.global_position
	bullet.velocity = Vector2(direction, 0) * 200  # Enemy bullet speed

	# Change bullet color to red
	bullet.modulate = bullet_color

	# Mark this bullet as non-consumable by the player
	bullet.set_meta("consumable", false)
