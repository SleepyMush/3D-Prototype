extends Control

func _on_reload_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
