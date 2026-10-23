extends Node2D

@export var button_name: String 

@onready var shape_node: CollisionShape2D = $Area2D/CollisionShape2D
@onready var area_node: Area2D = $Area2D
@onready var sprite_node: AnimatedSprite2D = $AnimatedSprite2D 

var inside = false

signal pressed

func _ready() -> void:
	area_node.mouse_entered.connect(_on_hitbox_area_entered)
	area_node.mouse_exited.connect(_on_hitbox_area_exited)
	
func _on_hitbox_area_entered():
	inside = true
	
func _on_hitbox_area_exited():
	inside = false
	
func _input(event):
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and inside:
		if event.pressed:
			# the button should animate to the downward frame
			sprite_node.frame = 1;
		else:
			# the button should pop back up and do the released event
			sprite_node.frame = 0;
			pressed.emit(button_name)
			
		
