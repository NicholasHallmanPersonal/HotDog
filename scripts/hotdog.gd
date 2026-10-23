class_name HotDog extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

enum HOTDOG_STATES {IDLE, WARM, CHOSE_DRESS, DRESS, JUICE}
var cur_state = HOTDOG_STATES.IDLE

var cur_frame = 0
var state_animations = [
	[0, 1],
	[2, 3, 4, 5]
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var delay = 0.5
var cur = 0

func change_state(state_name: String) -> void:
	match state_name:
		"idle":
			cur_state = HOTDOG_STATES.IDLE
			cur_frame = 0
		"warm":
			cur_state = HOTDOG_STATES.WARM
			cur_frame = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cur += delta
	if cur > delay:
		cur = 0
		sprite.frame = state_animations[cur_state][cur_frame]
		cur_frame += 1
		if cur_frame >= len(state_animations[cur_state]):
			cur_frame = 0
