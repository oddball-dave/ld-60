class_name Main extends Node2D

enum DrawMode{normal,decoration,magic,motor,passthrough,eraser}

@export var skater_boy : PackedScene
@export var checkpoints_scenes : Array[PackedScene]
@export var background_textures : Array[Texture2D]

@onready var music: AudioStreamPlayer = $GUI/MP3Player/Music
@onready var drawer: Drawer = $Drawer
@onready var background: Sprite2D = $Background
@onready var wobble_layer: CanvasLayer = $WobbleLayer

var sk8er_boi : Node2D
var check_points: CheckPoints

func _ready() -> void:
	wobble_layer.visible = true
	
	_load_level(0)
	
	play_pause()

func _load_level( index : int ):
	background.texture = background_textures[index]
	if check_points:
		remove_child(check_points)
		check_points.queue_free()
		check_points = null
	
	check_points = checkpoints_scenes[index].instantiate()
	check_points.name = "Checkpoints"
	add_child(check_points)
	check_points.owner = self
	
	drawer.clear()
	_reset()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("save_drawer"):
		var scene := PackedScene.new()
		scene.pack(drawer)
		ResourceSaver.save(scene, "res://level_scenes/saved_drawer.tscn")

func _start():
	sk8er_boi = skater_boy.instantiate()
	sk8er_boi.transform = check_points.get_start_transform()
	add_child(sk8er_boi)
	check_points.sk8ter_boi = sk8er_boi
	get_tree().paused = true

func _reset():
	if sk8er_boi: sk8er_boi.queue_free()
	sk8er_boi = null
	check_points.reset()
	drawer.reset()
	get_tree().paused = true

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
