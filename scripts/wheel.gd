class_name Wheel extends RigidBody2D

const TORQUE_FORCE : float = 40000

func _process(delta: float) -> void:
	constant_torque = move_toward(constant_torque, 0, TORQUE_FORCE * .2)

func _on_body_entered(body: Node) -> void:
	var line_segment : LineSegment = body.get_parent() as LineSegment
	
	if line_segment:
		if line_segment.destructable:
			line_segment.width_reduction_speed = 8
		if line_segment.booster:
			constant_torque = TORQUE_FORCE * sign(angular_velocity)
