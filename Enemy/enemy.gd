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

enum ENEMY_STATE {IDLE, ENRAGE, SEEK}
var current_state : int = 0

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
			pass
	
	move_and_slide()

func target_look() -> void:
		var target_angle = Vector2(player_ref.ref.global_position.z, player_ref.ref.global_position.x).angle_to_point(Vector2(global_position.z, global_position.x))
		rotation.y = target_angle

#have a way
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body ==  player_ref.ref:
		current_state = ENEMY_STATE.ENRAGE
		

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body ==  player_ref.ref:
		current_state = ENEMY_STATE.SEEK

func _on_timer_timeout() -> void:
	current_state = ENEMY_STATE.IDLE
	timer.stop()

func _on_damage_taken(damage_amount: float) -> void:
	health_node.damage_taken(damage_amount)
	print("Enemy_damage ", damage_amount)
