extends Node

@onready var transition: AnimationPlayer = $Transition

func _ready() -> void:
	transition.play("Fade_In")

#Close the game
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
