extends Control

@onready var transition: AnimationPlayer = $Transition
var level = preload("res://main_node.tscn")

func _on_button_pressed() -> void:
	transition.play("Fade_Out")

func _on_transition_animation_finished(_anim_name: StringName) -> void:
	get_tree().change_scene_to_packed(level)

func Quit_button() -> void:
	get_tree().quit()
