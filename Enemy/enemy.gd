extends CharacterBody3D

# Add chase logic and ENrage logic, and what to do when they idle again
var current_speed : float = 3.0
var chase_speed   : float = 6.0

@export var player : CharacterBody3D
@onready var timer: Timer = $Node/Timer

enum ENEMY_STATE {IDLE, ENRAGE, SEEK}
var current_state : int = 0

func _ready() -> void:
	current_state = ENEMY_STATE.IDLE

func _physics_process(_delta: float) -> void:
	match current_state:
		ENEMY_STATE.ENRAGE:
			look_at(player.position)
			print("Enrage")
		ENEMY_STATE.SEEK:
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
		timer.start()

func _on_timer_timeout() -> void:
	current_state = ENEMY_STATE.IDLE
	timer.stop()
