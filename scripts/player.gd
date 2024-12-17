extends CharacterBody2D
class_name Player

enum PlayerState { IDLE, RUN, JUMP, FALL, SHOOT, RETRIEVE }

@export var SPEED := 139.0
@export var JUMP_VELOCITY := -400.0
@export var GRAVITY := 1000.0
@export var PROTAG_BULLET = preload("res://scenes/ProtagBullet.tscn")
@export var MAGAZINE_SIZE := 5

@onready var music: AudioStreamPlayer2D = $"../Music"
@onready var death_timer: Timer = Timer.new()
@onready var manager: Node = %Manager
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var gun_marker: Marker2D = $Node2D/GunMarker2D
@onready var state_machine: StateMachine = $StateMachine
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var death_sound: AudioStreamPlayer2D = $"../DeathSound"

var is_dying = false  
var is_shooting = false
var is_retrieving = false
var bullets_remaining = MAGAZINE_SIZE
const RESPAWN_POSITION = Vector2(30, -50)

func _ready():
	animated_sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))
	print("Player initialized and ready.")
	
	add_child(death_timer)
	death_timer.wait_time = 1.25
	death_timer.one_shot = true
	death_timer.connect("timeout", Callable(self, "_on_death_timer_timeout"))
	
func _physics_process(delta: float) -> void:
	if is_dying:
		return
	
	if not is_retrieving:
		if not is_on_floor():
			velocity += get_gravity() * delta

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		var direction := Input.get_axis("move_left", "move_right")
		
		if direction > 0:
			animated_sprite.flip_h = false
			gun_marker.position.x = abs(gun_marker.position.x)  
		elif direction < 0:
			animated_sprite.flip_h = true
			gun_marker.position.x = -abs(gun_marker.position.x)  

		if not is_shooting:
			if is_on_floor():
				if direction == 0:
					animated_sprite.play("idle")
				else:
					animated_sprite.play("run")
			else:
				animated_sprite.play("jump")
		
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if state_machine and not is_dying:
		state_machine._physics_process(delta)

func _on_animation_finished():
	if animated_sprite.animation == "shoot":
		if is_retrieving:
			manager.set_bullets(bullets_remaining)
			is_retrieving = false
		elif is_shooting:
			manager.set_bullets(bullets_remaining)
			is_shooting = false


func die() -> void:
	if is_dying:  
		return
		
	music.stop()
	death_sound.play()
	print("Player died.")
	is_dying = true
	state_machine.set_physics_process(false)  

	animated_sprite.play("death")
	death_timer.start()
	collision_shape.disabled = true
	velocity = Vector2.ZERO  


func _on_death_timer_timeout():
	print("Death timer finished. Respawning...")

	if manager.player_lives > 1:
		manager.lose_life()
		_respawn()
		velocity = Vector2.ZERO
		set_physics_process(true)
		print("Player respawned.")
	else:
		print("Game Over")
		manager.show_game_over()

func _respawn():
	print("Respawning player...")
	is_dying = false  
	collision_shape.disabled = false
	global_position = RESPAWN_POSITION
	velocity = Vector2.ZERO
	music.play()
	animated_sprite.play("idle")
