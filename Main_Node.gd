extends Node

@onready var transition: AnimationPlayer = $Transition
@onready var marker: Marker3D = $Marker3D
const ENEMY = preload("res://Enemy/enemy.tscn")

func _ready() -> void:
	transition.play("Fade_In")
	
#	Spawn location of enemy
	var enemy = ENEMY.instantiate()
	enemy.position = marker.position
	add_child(enemy)

#Close the game
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
