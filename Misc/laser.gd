extends Node3D

@onready var ray_cast: RayCast3D = $RayCast3D
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

func _process(_delta: float) -> void:
	if ray_cast.is_colliding():
		pass
