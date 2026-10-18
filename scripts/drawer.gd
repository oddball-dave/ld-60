class_name Drawer extends Node2D

const MAX_SEGMENT_LENGTH : int = 10
const ERASER_RADIUS : float = 10

var current_segment : LineSegment
var using_ruler : bool = false
var draw_mode : Main.DrawMode
var is_erasing : bool = false

@export var drawable_area : Rect2
@export var line_segment : PackedScene
@export var deco_segment : PackedScene
@export var magi_segment : PackedScene
@export var moto_segment : PackedScene
@export var pass_segment : PackedScene

@onready var scribble_sfx: AudioStreamPlayer = $ScribbleSFX
@onready var rub_out_sfx: AudioStreamPlayer = $RubOutSFX

func reset():
	for node in get_children():
		if node is LineSegment: node.reset()

func clear():
	for node in get_children():
		if node is LineSegment: node.queue_free()

func get_new_segment() -> LineSegment:
	match draw_mode:
		Main.DrawMode.normal:
			return line_segment.instantiate()
		Main.DrawMode.decoration:
			return deco_segment.instantiate()
		Main.DrawMode.magic:
			return magi_segment.instantiate()
		Main.DrawMode.motor:
			return moto_segment.instantiate()
		Main.DrawMode.passthrough:
			return pass_segment.instantiate()
	
	return line_segment.instantiate()

func _ready() -> void:
	scribble_sfx.stream_paused = true
	rub_out_sfx.stream_paused = true

func _process(_delta: float) -> void:
	
	if is_erasing:
		if Input.is_action_just_released("click"):
			is_erasing = false
			rub_out_sfx.stream_paused = true
		else:
			var mouse_pos : Vector2 = get_viewport().get_mouse_position()
			var index = 0
			while index < get_child_count():
				var segment : LineSegment = get_child(index) as LineSegment
				if segment:
					if Geometry2D.is_point_in_circle(segment.start,mouse_pos,ERASER_RADIUS) or\
						Geometry2D.is_point_in_circle(segment.end,mouse_pos,ERASER_RADIUS) or\
						Geometry2D.segment_intersects_circle(segment.start,segment.end,mouse_pos,ERASER_RADIUS) >= 0:
						remove_child(segment)
						segment.queue_free()
					else:
						index += 1
				else:
					index += 1
				
				if Input.get_last_mouse_velocity().length() > 0.1 and\
					drawable_area.has_point(mouse_pos):
					rub_out_sfx.stream_paused = false
				else:
					rub_out_sfx.stream_paused = true
			
			
	
	elif current_segment:
		var mouse_pos : Vector2 = get_viewport().get_mouse_position()
		if !using_ruler:
			while current_segment.start.distance_to(mouse_pos) > 10:
				var cut_point : Vector2 = current_segment.start.move_toward(mouse_pos,10)
				current_segment.end = cut_point
				current_segment = get_new_segment()
				add_child(current_segment)
				current_segment.owner = self
				current_segment.start = cut_point
		
		current_segment.end = mouse_pos
		
		if Input.is_action_just_released("click"):
			scribble_sfx.stream_paused = true
			if using_ruler:
				while current_segment.start.distance_to(mouse_pos) > 10:
					var cut_point : Vector2 = current_segment.start.move_toward(mouse_pos,10)
					current_segment.end = cut_point
					current_segment = get_new_segment()
					add_child(current_segment)
					current_segment.owner = self
					current_segment.start = cut_point
					current_segment.end = mouse_pos
			
			
			current_segment = null
		else:
			if Input.get_last_mouse_velocity().length() > 0.1 and\
				drawable_area.has_point(mouse_pos):
				scribble_sfx.stream_paused = false
			else:
				scribble_sfx.stream_paused = true
	
	elif Input.is_action_just_pressed("click"):
		var mouse_pos := get_viewport().get_mouse_position()
		if draw_mode == Main.DrawMode.eraser:
			is_erasing = true
			if drawable_area.has_point(mouse_pos): rub_out_sfx.stream_paused = false
		else:
			if drawable_area.has_point(mouse_pos): scribble_sfx.stream_paused = false
			current_segment = get_new_segment()
			add_child(current_segment)
			current_segment.owner = self
			current_segment.start = mouse_pos
			current_segment.end = mouse_pos
