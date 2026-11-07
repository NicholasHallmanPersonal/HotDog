class_name HotDog extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

enum HOTDOG_STATES { IDLE, WARM, DRESS_SELECT_1, DRESS_SELECT_2, DRESS_SELECT_3, DRESS_1, DRESS_2, DRESS_3, JUICE, NICE, START }
var cur_state = HOTDOG_STATES.START

signal looped

var cur_frame = 0
var state_animations = [
	[0, 1],
	[2, 3, 4, 5],
	[6],
	[7],
	[8],
	[9, 10],
	[11, 12],
	[13, 14],
	[15, 16, 17],
	[18, 19, 20],
	[21]
]


func _ready() -> void:
	pass

var delay = 0.5
var cur = 0

var loop_complete = false

func reset():
	cur = delay
	loop_complete = false

func change_state(state_name: String) -> void:
	cur_frame = 0
	match state_name:
		"idle":
			cur_state = HOTDOG_STATES.IDLE
			delay = 0.5
			reset()
		"warm":
			cur_state = HOTDOG_STATES.WARM
			delay = 0.5
			reset()
		"juice":
			cur_state = HOTDOG_STATES.JUICE
			delay = 0.4
			reset()
			generate_spray_dodge_frames()
		"dress_select_1":
			cur_state = HOTDOG_STATES.DRESS_SELECT_1
			delay = 0.1
			reset()
		"dress_select_2":
			cur_state = HOTDOG_STATES.DRESS_SELECT_2
			delay = 0.1
			reset()
		"dress_select_3":
			cur_state = HOTDOG_STATES.DRESS_SELECT_3
			delay = 0.1
			reset()
		"dress_1":
			cur_state = HOTDOG_STATES.DRESS_1
			delay = 2
			reset()
		"dress_2":
			cur_state = HOTDOG_STATES.DRESS_2
			delay = 2
			reset()
		"dress_3":
			cur_state = HOTDOG_STATES.DRESS_3
			delay = 2
			reset()
		"nice":
			cur_state = HOTDOG_STATES.NICE
			delay = 0.3
			reset()
		"start":
			cur_state = HOTDOG_STATES.START
			delay = 1
			reset()

func generate_spray_dodge_frames():
	state_animations[HOTDOG_STATES.JUICE] = []
	for i in range(0, 10):
		state_animations[HOTDOG_STATES.JUICE].append(randi_range(15, 17))


func _process(delta: float) -> void:
	cur += delta
	if cur > delay:
		if cur_frame == 0 and loop_complete:
			loop_complete = false
			looped.emit()
		cur = 0
		sprite.frame = state_animations[cur_state][cur_frame]
		cur_frame += 1
		if cur_frame >= len(state_animations[cur_state]):
			loop_complete = true
			cur_frame = 0
			if cur_state == HOTDOG_STATES.NICE:

				cur_frame = 2
			if cur_state == HOTDOG_STATES.JUICE:
				generate_spray_dodge_frames()

func get_spray_position() -> String:
	if cur_state == HOTDOG_STATES.JUICE:
		match sprite.frame:
			15:
				return "left"
			16:
				return "center"
			17:
				return "right"
	return "unknown"
