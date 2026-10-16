class_name Main extends Node2D

func _input(event):
	if event.is_action("ui_cancel") and not event.is_echo() and event.is_pressed():
		get_node("PauseMenu").visible = true
		get_tree().paused = true
		get_viewport().set_input_as_handled()
