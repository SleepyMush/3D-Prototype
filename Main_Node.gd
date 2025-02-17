extends Node

@onready var transition: AnimationPlayer = $Transition
const ENEMY = preload("res://Enemy/enemy.tscn")
const MEDICAL_PACKS = preload("res://Components/Medical_pack.tscn")
var MENU = load("res://UI/menu.tscn")
var markers: Array[Node] 
var markers_medic: Array[Node] 

func _ready() -> void:
	transition.play("Fade_In")
	spawn_markers()
	Spawn_Medic_Markers()

#Close the game
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().change_scene_to_file("res://UI/menu.tscn")

func spawn_markers() :
	# Spawn location of enemy
	markers = get_tree().get_nodes_in_group("markers")
	for marker in markers:
		var enemy = ENEMY.instantiate()
		enemy.player = $Base/Player
		enemy.position = marker.position
		add_child(enemy)

func Spawn_Medic_Markers() :
	markers_medic = get_tree().get_nodes_in_group("Medic_packs")
	for marker in markers_medic:
		var medic = MEDICAL_PACKS.instantiate()
		medic.position = marker.position
		add_child(medic)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		get_tree().reload_current_scene()
