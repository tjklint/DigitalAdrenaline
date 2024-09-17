extends CharacterBody2D

var bullet_velocity = Vector2(1, 0)
var speed = 300

func _physics_process(delta: float) -> void:
	# Move the bullet and check for collision
	var collision_info = move_and_collide(bullet_velocity.normalized() * delta * speed)
	if collision_info:
		# If bullet collides with something, queue_free the bullet
		queue_free()
