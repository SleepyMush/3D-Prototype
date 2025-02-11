class_name Enemy
extends CharacterBody3D

# Enrage and Chase works, now to figure out idle
var current_speed : float = 0.100
var chase_speed   : float = 1.0

var distance_chased_from : float = 0.100
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#var player : CharacterBody3D  = GlobalVar.player
var player_ref : ReferenceData = preload("res://Resource/Player_ref.tres")
@onready var timer: Timer = $Node/Timer
@onready var health_node: Health_Node = $Health_Node

enum ENEMY_STATE {IDLE, ENRAGE, SEEK, DEAD}
var current_state : int = 0

signal got_hit(damage_taken : float)

func _ready() -> void:
	current_state = ENEMY_STATE.IDLE

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	match current_state:
		ENEMY_STATE.ENRAGE:
			target_look()
			
		ENEMY_STATE.SEEK:
			global_position = lerp(global_position, player_ref.ref.global_position, current_speed * delta)
			if player_ref.ref.global_position.distance_to(global_position) >= distance_chased_from:
				current_speed = chase_speed
				if timer.is_stopped():
					timer.start()
			target_look()
			
		ENEMY_STATE.IDLE:
#			Seriously, what should i add here
			pass
			
		ENEMY_STATE.DEAD:
#			IDK, play dead animation and spawn in a model
			if health_node.health == 0:
				queue_free()
	
	move_and_slide()

func target_look() -> void:
		var target_angle = Vector2(player_ref.ref.global_position.z, player_ref.ref.global_position.x).angle_to_point(Vector2(global_position.z, global_position.x))
		rotation.y = target_angle

#have a way
func _on_area_3d_body_entered(body: Node3D) -> void:
	print(body)
	if body is Player:
		current_state = ENEMY_STATE.ENRAGE
		body.hit(10)
		

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body ==  player_ref.ref:
		current_state = ENEMY_STATE.SEEK

func _on_timer_timeout() -> void:
	current_state = ENEMY_STATE.IDLE
	timer.stop()


func hit(value: float) -> void:
	health_node.take_damage(value)
	print("Enemy_damage ", value)
	
	emit_signal("got_hit", value)
	
	if health_node.health <= 0:
		current_state = ENEMY_STATE.DEAD
