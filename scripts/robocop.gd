extends Enemy
class_name Robocop

const BULLET = preload("res://scenes/EnemyBullet.tscn") 
const BulletType = preload("res://scripts/bullet_factory.gd").BulletType 
const ENEMY_SPEED = 60
const FIRE_COOLDOWN = 2.0

@onready var shoot: AudioStreamPlayer2D = $Shoot
@onready var gun_marker: Marker2D = $Marker2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var player_detector_left: RayCast2D = $PlayerDetectorLeft
@onready var player_detector_right: RayCast2D = $PlayerDetectorRight


var can_fire = true

func _process(delta: float) -> void:
	var can_move = true

	if direction == -1 and not ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = true
		toggle_player_detectors()
		can_move = false
	elif direction == 1 and not ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = false
		toggle_player_detectors()
		can_move = false

	if can_move:
		position.x += direction * ENEMY_SPEED * delta

	if can_fire and (player_detector_left.is_colliding() or player_detector_right.is_colliding()):
		fire_bullet()

func fire_bullet():
	print("Enemy is firing")
	var bullet = BulletFactory.create_bullet(BulletType.ENEMY_BULLET)
	if bullet:
		shoot.play()
		bullet.position = gun_marker.global_position
		bullet.bullet_velocity = Vector2(direction, 0)
		get_tree().root.add_child(bullet)

	var cooldown_timer = Timer.new()
	cooldown_timer.wait_time = FIRE_COOLDOWN
	cooldown_timer.one_shot = true
	cooldown_timer.connect("timeout", Callable(self, "_on_fire_cooldown_done"))
	add_child(cooldown_timer)
	cooldown_timer.start()

	can_fire = false

func toggle_player_detectors():
	player_detector_left.enabled = (direction == -1)
	player_detector_right.enabled = (direction == 1)

func _on_fire_cooldown_done():
	can_fire = true
