extends Enemy
class_name Robocop

const BULLET = preload("res://scenes/EnemyBullet.tscn")  # Preload bullet scene
const ENEMY_SPEED = 60

@export var bullet_color: Color = Color(1, 0, 0)  # Red color for enemy bullets
@onready var gun_marker: Node2D = $GunMarker  # Position to spawn bullets from
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	if direction == -1 and not ray_cast_left.is_colliding(): 
		direction = 1
		animated_sprite.flip_h = true
	elif direction == 1 and not ray_cast_right.is_colliding():  
		direction = -1
		animated_sprite.flip_h = false
		
	position.x += direction * ENEMY_SPEED * delta
	
