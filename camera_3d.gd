extends Camera3D

@export var player : Player
var Direction : Vector3
@onready var overview_camera: Node3D = $".."
signal update_camera_pos(ray, pos)
@onready var camera_3d: Camera3D = $"."

var Near: float = 0.001
var Far: float = 4000
var Size: float = 20

#Sets the process to true
func _ready() -> void:
	Direction = player.global_position - camera_3d.global_position 
	camera_3d.projection = Camera3D.PROJECTION_ORTHOGONAL
	camera_3d.set_orthogonal(Size, Near, Far)
	set_process(true)

#Input for the camera, to look into the scene and cast a ray, or i think
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_position = event.global_position
		var camera = get_viewport().get_camera_3d()
		var ray = camera.project_ray_origin(mouse_position)
		update_camera_pos.emit(-camera.global_transform.basis.z, ray)

#Follow Enitiy Code
func _process(delta: float) -> void:
	if player:
		global_position =  player.global_position - Direction
