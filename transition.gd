
class_name Transition

enum Ease { EASE_OUT, EASE_IN }
	
var keyframes: Array
var ease: Ease
var duration: float
var current: float

func _init(frames: Array, duration: float, ease: Ease):
	self.keyframes = frames
	self.ease = ease
	self.duration = duration
	self.current = 0

func start():
	self.current = 0

func next(frame: Variant, duration: float, ease: Ease):
	self.keyframes[0] = get_v(0)
	self.keyframes[1] = frame
	self.ease = ease
	self.duration = duration
	self.current = 0

func get_ease(t: float):
	match ease:
		Ease.EASE_OUT:
			return 1 - (1 - t) * (1 - t)
		Ease.EASE_IN:
			return t * t
	
func get_v(delta: float) -> Variant:
	current += delta
	var t = min(1, (current + delta) / duration)
	var e = get_ease(t)
	var v = (keyframes[0] * (1 - e)) + (keyframes[1] * e)
	return v
