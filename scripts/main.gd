class_name Main extends Node2D

enum DrawMode{normal,decoration,magic,motor,passthrough,eraser}

@export var skater_boy : PackedScene

@onready var check_points: CheckPoints = $CheckPoints
@onready var drawer: Drawer = $Drawer

var sk8er_boi : Node2D

func _start():
	sk8er_boi = skater_boy.instantiate()
	sk8er_boi.transform = check_points.get_start_transform()
	add_child(sk8er_boi)
	check_points.sk8ter_boi = sk8er_boi

func _reset():
	if sk8er_boi: sk8er_boi.queue_free()
	sk8er_boi = null
	check_points.reset()
	drawer.reset()

func play_pause():
	if not sk8er_boi: 
		_start()
		get_tree().paused = false
	else: get_tree().paused = !get_tree().paused
	get_viewport().set_input_as_handled()

func _normal_toggle( on : bool ):
	if on: drawer.draw_mode = DrawMode.normal

func _decoration_toggle( on : bool ):
	if on: drawer.draw_mode = DrawMode.decoration

func _magic_toggle( on : bool ):
	if on: drawer.draw_mode = DrawMode.magic

func _motor_toggle( on : bool ):
	if on: drawer.draw_mode = DrawMode.motor

func _passthrough_toggle( on : bool ):
	if on: drawer.draw_mode = DrawMode.passthrough

func _eraser_toggle( on : bool ):
	if on: drawer.draw_mode = DrawMode.eraser

func _ruler_toggle( on : bool ):
	drawer.using_ruler = on
