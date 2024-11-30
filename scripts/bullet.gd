extends CharacterBody2D

var bullet_velocity = Vector2(1, 0)
var speed = 200
var has_bounced = false  
var returning = false

@export var return_range = 75.0
var player: CharacterBody2D

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(bullet_velocity.normalized() * speed * delta)
	
	if collision:
		var body = collision.get_collider()
		if body is Enemy:
			body.die()
		elif body is Player:
			body.die()
			queue_free()
	
		if has_bounced:
			queue_free()
		else: 
			bullet_velocity = -bullet_velocity
			has_bounced = true
				
	else: 
		position += bullet_velocity.normalized() * speed * delta
			
