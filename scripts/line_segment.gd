class_name LineSegment extends Line2D

@onready var collider: CollisionShape2D = $StaticBody2D/CollisionShape2D

@export var destructable : bool = false
@export var booster : bool = false

var width_reduction_speed : float = 0

var start : Vector2:
	get:
		return get_point_position(0)
	set(value):
		set_point_position(0,value)
		if collider: collider.shape.a = value

var end : Vector2:
	get:
		return get_point_position(1)
	set(value):
		set_point_position(1,value)
		if collider:
			collider.shape.b = value
			collider.one_way_collision_direction = collider.shape.b.direction_to(collider.shape.a).orthogonal()

func _process(delta: float) -> void:
	width -= width_reduction_speed * delta
	if width <= 0:
		collider.disabled = true

func reset():
	width_reduction_speed = 0
	width = 4
	if destructable: collider.disabled = false
