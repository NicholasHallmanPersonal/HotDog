extends Node2D

@export var button_name: String

@onready var shape_node: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite_node: AnimatedSprite2D = $AnimatedSprite2D

# Pointer id that currently owns this button: a touch finger index, MOUSE_ID
# for the mouse, or NO_POINTER when the button isn't being held.
const NO_POINTER := -1
const MOUSE_ID := -100
var pointer := NO_POINTER

signal pressed


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			_pointer_down(event.index, event.position)
		else:
			_pointer_up(event.index, event.position)
	elif event is InputEventScreenDrag:
		_pointer_move(event.index, event.position)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_pointer_down(MOUSE_ID, event.position)
		else:
			_pointer_up(MOUSE_ID, event.position)
	elif event is InputEventMouseMotion:
		_pointer_move(MOUSE_ID, event.position)


func _pointer_down(id: int, pos: Vector2) -> void:
	if pointer != NO_POINTER or not is_visible_in_tree() or not _hit(pos):
		return
	pointer = id
	_set_down(true)


func _pointer_move(id: int, pos: Vector2) -> void:
	if id != pointer:
		return
	# Down only while the finger/cursor is over the button.
	_set_down(_hit(pos))


func _pointer_up(id: int, pos: Vector2) -> void:
	if id != pointer:
		return
	var was_inside := _hit(pos)
	_cancel()
	# Only count it as a press if released while still over the button.
	if was_inside:
		pressed.emit(button_name)


# Pop the button back up and forget the pointer without firing a press.
func _cancel() -> void:
	pointer = NO_POINTER
	_set_down(false)


func _set_down(down: bool) -> void:
	sprite_node.frame = 1 if down else 0


# Is a viewport-space point inside this button's collision rectangle?
func _hit(viewport_pos: Vector2) -> bool:
	var rect_shape := shape_node.shape as RectangleShape2D
	if rect_shape == null:
		return false
	var world := get_canvas_transform().affine_inverse() * viewport_pos
	var local := shape_node.get_global_transform().affine_inverse() * world
	return Rect2(-rect_shape.size / 2.0, rect_shape.size).has_point(local)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_VISIBILITY_CHANGED, NOTIFICATION_APPLICATION_FOCUS_OUT, \
		NOTIFICATION_WM_WINDOW_FOCUS_OUT, NOTIFICATION_EXIT_TREE:
			if pointer != NO_POINTER and sprite_node:
				_cancel()
