class_name Medic
extends Node3D

@onready var area: Area3D = $MeshInstance3D/Area3D
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
var tween_top_pos : Vector3 = Vector3(0, 0.1, 0)
var tween_bottom_pos : Vector3 = Vector3(0, -0.1, 0)
var tween_movement_time : float = .5

var health_node : Health_Node

func _ready() -> void:
	_position()

func _position():
	var tween = get_tree().create_tween()
	tween.tween_property(mesh_instance, "global_position", Vector3(global_position + tween_top_pos), tween_movement_time).set_trans(tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	var _tween = get_tree().create_tween()
	_tween.tween_property(mesh_instance, "global_position", Vector3(global_position + tween_bottom_pos), tween_movement_time).set_trans(tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	await _tween.finished

	_position()

func _on_health_healed(value: float) -> void:
	if health_node.health < health_node.max_health:
		health_node.heal(value)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		if body.health_node.health < body.health_node.max_health and body.health_node.health > 0:
			body.health_node.heal(10)
			queue_free()
