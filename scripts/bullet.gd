extends CharacterBody2D

var bullet_velocity = Vector2(1, 0)
var speed = 300
var has_bounced = false  
var returning = false

@export var return_range = 50.0
var player: CharacterBody2D

func _physics_process(delta: float) -> void:
	if returning and player:		
		bullet_velocity = (player.global_position - global_position).normalized()
	else: 
		velocity = bullet_velocity.normalized() * speed
	
	move_and_slide()
	
	if is_on_floor() or is_on_wall():
		if has_bounced:
			queue_free()
		else: 
			bullet_velocity = -bullet_velocity
			has_bounced = true
