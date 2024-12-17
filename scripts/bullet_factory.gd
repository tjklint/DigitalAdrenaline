extends Node

static func create_bullet(bullet_type: String) -> Node:
	var bullet_scene: PackedScene

	match bullet_type:
		"ProtagBullet":
			bullet_scene = preload("res://scenes/ProtagBullet.tscn")
		"EnemyBullet":
			bullet_scene = preload("res://scenes/EnemyBullet.tscn")
		_:
			push_error("Unknown bullet type: " + bullet_type)
			return null

	return bullet_scene.instantiate() if bullet_scene else null
