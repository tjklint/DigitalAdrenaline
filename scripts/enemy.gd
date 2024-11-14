extends CharacterBody2D
class_name Enemy

@export var speed: float = 80.0
@export var patrol_distance: float = 100.0  
@export var shooting_cooldown: float = 2.0  

var start_position: Vector2
var direction: int = -1  
var time_since_last_shot: float = 0.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	start_position = global_position
	
func patrol(delta):
	velocity.x = direction * speed
	move_and_slide()
	
	if abs(global_position.x - start_position.x) >= patrol_distance:
		direction *= -1
		animated_sprite.flip_h = direction < 0
		
func shoot():
	pass
