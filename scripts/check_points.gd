class_name CheckPoints extends Node2D

const CHECKPOINT_RADIUS : int = 50

var next_checkpoint = 0
var sk8ter_boi : Node2D
var confetti : PackedScene

func _ready() -> void:
	confetti = preload("res://scenes/confetti.tscn")

func _process(delta: float) -> void:
	if next_checkpoint >= get_child_count(): return
	if sk8ter_boi == null: return
	
	var check_point : Sprite2D = get_child(next_checkpoint) as Sprite2D
	
	if sk8ter_boi.position.distance_to(check_point.position) < CHECKPOINT_RADIUS:
		if next_checkpoint > 0:
			var con := confetti.instantiate() as GPUParticles2D
			con.emitting = true
			get_tree().root.add_child(con)
			con.position = check_point.position
		check_point.visible = false
		next_checkpoint += 1

func get_start_transform() -> Transform2D:
	return get_child(0).transform

func reset():
	next_checkpoint = 0
	sk8ter_boi = null
	for node in get_children():
		node.visible = true
