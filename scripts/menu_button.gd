class_name GameMenuButton extends Button

const TRANS_TIME : float = .5

@export var hover_color : Color = Color.GRAY
@export var normal_color : Color = Color.LIGHT_GRAY

var tween : Tween

func _play() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main.tscn")

func _title() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://title_screen.tscn")

func _unpause() -> void:
	get_tree().paused = false
	owner.visible = false

func _exit() -> void:
	get_tree().quit()

func _on_focus_entered() -> void:
	if tween: tween.kill()
	
	var focus_stylebox : StyleBoxFlat = get_theme_stylebox("focus")
	focus_stylebox.bg_color = Color.WHITE
	var hover_stylebox : StyleBoxFlat = get_theme_stylebox("hover")
	hover_stylebox.bg_color = Color.WHITE
	
	tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(focus_stylebox,"bg_color",hover_color,TRANS_TIME)
	tween.parallel().tween_property(hover_stylebox,"bg_color",hover_color,TRANS_TIME)


func _on_focus_exited() -> void:
	if tween: tween.kill()
	
	var normal_stylebox : StyleBoxFlat = get_theme_stylebox("normal")
	normal_stylebox.border_color = Color.WHITE
	
	
	tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(normal_stylebox,"border_color",normal_color,TRANS_TIME)
	
