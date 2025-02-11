extends Node

@onready var transition: AnimationPlayer = $Transition
const ENEMY = preload("res://Enemy/enemy.tscn")
var markers: Array[Node] 

func _ready() -> void:
	transition.play("Fade_In")
	spawn_markers()

#Close the game
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()

func spawn_markers() :
	# Spawn location of enemy
	markers = get_tree().get_nodes_in_group("markers")
	for marker in markers:
		var enemy = ENEMY.instantiate()
		enemy.player = $Base/Player
		print( markers.pick_random())
		enemy.position = marker.position
		add_child(enemy)
