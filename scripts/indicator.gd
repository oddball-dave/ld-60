class_name Indicator extends TextureRect

func _process(delta: float) -> void:
	visible = !get_tree().paused
