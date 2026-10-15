class_name Main extends Node2D

func _input(event):
	if event is InputEventKey and not event.is_echo() and event.is_pressed() and event.keycode == KEY_ESCAPE:
		get_node("PauseMenu").visible = true
		get_tree().paused = true
