class_name Menu extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

signal selected_item

var opened: bool = false
var items = ["home", "stats", "warm", "dress", "juice"]
var transition: Transition

func open():
	print("opening")
	sprite.frame = 0
	if typeof(transition) == TYPE_NIL:
		transition = Transition.new([position.y, 9], 0.5, Transition.Ease.EASE_OUT)
	else:
		transition.next(9, 0.5, Transition.Ease.EASE_OUT)
	transition.start()
	opened = true

func close():
	print("closing")
	transition.next(-1, 0.5, Transition.Ease.EASE_IN)
	transition.start()
	opened = false

func _process(delta: float):
	if typeof(transition) != TYPE_NIL:
		var new_pos = transition.get_v(delta)
		position.y = new_pos

func handle_button(button_name: String):
	print("button name ", button_name)
	match button_name:
		"right":
			if sprite.frame >= 4: return
			sprite.frame += 1
		"left":
			if sprite.frame == 0: return
			sprite.frame -= 1
		"select":
			selected_item.emit(items[sprite.frame])
