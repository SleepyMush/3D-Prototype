extends CharacterBody3D

# Add chase logic and ENrage logic, and what to do when they idle again
var current_speed : float = 0.100
var chase_speed   : float = 1.0

var distance_chased_from : float = 0.100
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var player : CharacterBody3D
@onready var timer: Timer = $Node/Timer

enum ENEMY_STATE {IDLE, ENRAGE, SEEK}
var current_state : int = 0

func _ready() -> void:
	current_state = ENEMY_STATE.IDLE

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	match current_state:
		ENEMY_STATE.ENRAGE:
			print("Enrage")
		ENEMY_STATE.SEEK:
			global_position = lerp(global_position,player.global_position, current_speed * delta)
			if player.global_position.distance_to(global_position) >= distance_chased_from:
				current_speed = chase_speed
				if timer.is_stopped():
					timer.start()
			print("Seek_player")
		ENEMY_STATE.IDLE:
			print("Idle")
	
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == player:
		current_state = ENEMY_STATE.ENRAGE

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == player:
		current_state = ENEMY_STATE.SEEK
		#timer.start()

func _on_timer_timeout() -> void:
	current_state = ENEMY_STATE.IDLE
	timer.stop()
