class_name StateMachine

var states = {}
var state_functions = {}

func _init(states: Dictionary, default: String):
	self.states = states
	set_state(default, [])

func set_state(state, args: Array[Variant] = []):
	if self.states.has(state):
		print("found state")
		var transition: Callable = self.states[state]
		transition.call(args)
