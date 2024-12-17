extends Node

@export var protag_bullet_scene: PackedScene = preload("res://scenes/ProtagBullet.tscn")
@export var enemy_bullet_scene: PackedScene = preload("res://scenes/EnemyBullet.tscn")

func spawn_bullet(bullet_type: String, spawn_position: Vector2, direction: Vector2, parent: Node) -> Node2D:
	var bullet_instance: Node2D = null
	
	if bullet_type == "ProtagBullet":
		bullet_instance = protag_bullet_scene.instantiate()
	elif bullet_type == "EnemyBullet":
		bullet_instance = enemy_bullet_scene.instantiate()
	else:
		push_error("Invalid bullet type: " + bullet_type)
		return null
	
	bullet_instance.position = spawn_position
	if bullet_instance.has("bullet_velocity"):
		bullet_instance.bullet_velocity = direction.normalized()
	
	parent.add_child(bullet_instance)
	return bullet_instance
