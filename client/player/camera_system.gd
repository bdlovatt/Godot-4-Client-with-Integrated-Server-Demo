extends Node3D

const MOUSE_SENSITIVITY := 0.25


func _input(_event: InputEvent) -> void:
	if _event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation_degrees.y += -_event.relative.x * MOUSE_SENSITIVITY
