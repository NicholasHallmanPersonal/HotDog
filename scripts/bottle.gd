class_name Bottle extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var center = 0.0
var left = -35.0
var right = 35.0

func move_left():
	if sprite.frame == 1: return
	print(self.position.x == center)
	if self.position.x == center:
		self.position.x = left
		print("??")
	elif self.position.x == left:
			self.position.x = left
	elif self.position.x == right:
			self.position.x = center

func move_right():
	if sprite.frame == 1: return
	if self.position.x == center:
		self.position.x = right
	elif self.position.x == left:
		self.position.x = center
	elif self.position.x == right:
		self.position.x = right

func spray():
	if sprite.frame == 1: return

	sprite.frame = 1
	await get_tree().create_timer(0.5).timeout
	sprite.frame = 0

func get_spray_position() -> String:
	if self.position.x == left:
			return "left"
	elif self.position.x == right:
			return "right"
	elif self.position.x == center:
		return "center"

	return "unknown"
