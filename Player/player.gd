class_name Player
extends CharacterBody3D 

#Player Variables
var current_speed : float = 5.0
var walking_speed : float = 5.0
var sprintSpeeds  : float = 8.0

var can_sprint: bool = true
var sprint_timer: float = 4.0 # 2s between sprints

#World Data
var direction = Vector3.ZERO
var sensitivity : float = 0.005
var jump_velocity : float = 5.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var health_node: Health_Node = $Health_Node
var collider

#Import Variables
@onready var overview_camera: Node3D = $"../OverviewCamera"
@onready var ray_cast: RayCast3D = $Node3D/RayCast3D
@onready var health_bar: ProgressBar = $"Control/HealthBar"

signal got_hit(damage_taken : float)

func _ready() -> void:
	health_bar.value = health_node.health

func _input(event):
	if event.is_action_pressed("Sprint"):
		current_speed = sprintSpeeds
		print("Timer Start")
	
	if event.is_action_released("Sprint"):
		can_sprint = false
		current_speed = walking_speed
		await get_tree().create_timer(sprint_timer).timeout
		can_sprint = true
		print("timer stop")
	
	if event.is_action_pressed("Fire"):
		if ray_cast.is_colliding():
			collider = ray_cast.get_collider()
			print(collider)
			if collider.get_parent() is Enemy:
				collider.get_parent().hit(10)

#Physics and Player Movement
func _physics_process(delta: float) -> void:
		# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
		# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity
	
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	direction = (overview_camera.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
		
	move_and_slide()

#Camera Raycast Look_at Func
func _on_camera_3d_update_camera_pos(ray: Variant, pos: Variant) -> void:
	var height = pos.y - global_position.y
	var adjusted_pos : Vector3 = pos
	adjusted_pos.y = global_position.y
	var lenght = adjusted_pos.distance_to(global_position)
	
	var raylenght = pow(height, 2) + pow(lenght, 2)
	raylenght = sqrt(raylenght)
	var newlookatpos = pos + ray * raylenght
	newlookatpos.y = global_position.y
	if newlookatpos.distance_to(global_position) > 0.1:
		look_at(newlookatpos)

func hit(value: float) -> void:
	health_node.take_damage(value)
	print("Player ", value)
	emit_signal("got_hit", value)


func _on_health_node_health_changed(health: float) -> void:
	health_bar.value = health
