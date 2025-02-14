extends Camera3D

@export var player : NodePath
@export var weight : float = 0.5
@onready var overview_camera: Node3D = $".."
signal update_camera_pos(ray, pos)

#Sets the process to true
func _ready() -> void:
	set_process(true)

#Input for the camera, to look into the scene and cast a ray, or i think
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_position = event.global_position
		var camera = get_viewport().get_camera_3d()
		var ray = camera.project_ray_origin(mouse_position)
		update_camera_pos.emit(-camera.global_transform.basis.z, ray)

#Follow Enitiy Code
func _process(_delta: float) -> void:
	if player:
		var player_node = get_node(player)
		global_position = lerp(overview_camera.global_position, player_node.global_position, weight)
