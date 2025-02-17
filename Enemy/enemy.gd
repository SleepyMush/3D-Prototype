class_name Enemy
extends CharacterBody3D

# Enrage and Chase works, now to figure out idle
var current_speed : float = 0.100
var chase_speed   : float = 1.0

var distance_chased_from : float = 0.100
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var player : Player 
@onready var timer: Timer = $Node/Timer
@onready var health_node: Health_Node = $Health_Node
@onready var Attack_timer: Timer = $Attack_Timer/Timer

enum ENEMY_STATE {IDLE, ENRAGE, SEEK, DEAD}
var current_state : int = 0

signal got_hit(damage_taken : float)

var damage: float = 10.0

func _ready() -> void:
	current_state = ENEMY_STATE.IDLE

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	match current_state:
		ENEMY_STATE.ENRAGE:
			target_look()
			
		ENEMY_STATE.SEEK:
			global_position = lerp(global_position, player.global_position, current_speed * delta)
			if player.global_position.distance_to(global_position) >= distance_chased_from:
				current_speed = chase_speed
				if timer.is_stopped():
					timer.start()
			target_look()
			
		ENEMY_STATE.IDLE:
			pass
			
		ENEMY_STATE.DEAD:
			if health_node.health == 0:
				queue_free()
	
	move_and_slide()

func target_look() -> void:
		var target_angle = Vector2(player.global_position.z, player.global_position.x).angle_to_point(Vector2(global_position.z, global_position.x))
		rotation.y = target_angle

#have a way
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		player = body
		current_state = ENEMY_STATE.ENRAGE
		player.hit(damage)
		Attack_timer.start()
		print("Attack_Timer start")

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body ==  player:
		current_state = ENEMY_STATE.SEEK
		Attack_timer.stop()
		print("Attack_timer finished")

func _on_timer_timeout() -> void:
	current_state = ENEMY_STATE.IDLE
	timer.stop()

func hit(value: float) -> void:
	health_node.take_damage(value)
	print("Enemy_damage ", value)
	
	emit_signal("got_hit", value)
	
	if health_node.health <= 0:
		current_state = ENEMY_STATE.DEAD

func _on_Attack_timeout() -> void:
	player.hit(damage)

#Figure out a way to get the enemy not to hit the player when leaving the areea body, at the moment this causes undefined behaviour
#And read more about timers and signals
