extends Node

enum BulletType { PROTAG_BULLET, ENEMY_BULLET }

static func create_bullet(bullet_type) -> Node:
	var bullet_scene: PackedScene
	match bullet_type:
		BulletType.PROTAG_BULLET:
			bullet_scene = preload("res://scenes/ProtagBullet.tscn")
		BulletType.ENEMY_BULLET:
			bullet_scene = preload("res://scenes/EnemyBullet.tscn")
		_:
			push_error("Unknown bullet type: " + str(bullet_type))
			return null

	return bullet_scene.instantiate() if bullet_scene else null
