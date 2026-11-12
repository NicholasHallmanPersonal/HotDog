extends Node2D

@onready var menu: Menu = $Menu
@onready var hotdog: HotDog = $Character
@onready var stats_control: StatsControl = $Stats
@onready var bottle: Bottle = $Bottle

var state_machine

var stats = {
	warmth = 100,
	modesty = 100,
	juiciness = 100
}

var last_stat_reduction = 0
var game_over = false

var handle_left: Callable = func (): pass
var handle_right: Callable = func (): pass
var handle_select: Callable = func (): pass
var handle_loop: Callable = func (): pass

func reset_buttons():
	handle_left = func (): pass
	handle_right = func (): pass
	handle_select = func (): pass
	handle_loop = func (): pass

func _ready() -> void:
	self.state_machine = StateMachine.new({
		"start": func (args):
			reset_buttons()
			hotdog.change_state("start")
			handle_select = func ():
				state_machine.set_state("home")
			,
		"home": func (args):
			reset_buttons()
			print(typeof(hotdog))
			menu.close()
			handle_select = func ():
				state_machine.set_state("menu")
			hotdog.change_state("idle"),
		"menu": func (args):
			menu.open()
			handle_left = func (): menu.handle_button("left")
			handle_right = func (): menu.handle_button("right")
			handle_select = func (): menu.handle_button("select"),
		"stats": func (args):
			reset_buttons()
			menu.close()
			stats_control.show()
			stats_control.update_bars(stats)
			handle_select = func ():
				stats_control.hide()
				state_machine.set_state("home"),
		"warm": func (args):
			menu.close()
			reset_buttons()
			hotdog.change_state("warm")
			await get_tree().create_timer(5).timeout
			stats.warmth += 30
			if stats.warmth > 100: stats.warmth = 100
			state_machine.set_state("home"),
		"juice": func (args):
			menu.close()
			reset_buttons()
			$Bottle.show()
			hotdog.change_state("juice")
			var hits = [0] # array so the lambda below mutates the shared value
			handle_left = func (): bottle.move_left()
			handle_right = func (): bottle.move_right()
			handle_select = func ():
				if bottle.sprite.frame == 1: return
				if hotdog.get_spray_position() == bottle.get_spray_position():
					hits[0] += 1
				bottle.spray()
			await get_tree().create_timer(10).timeout
			$Bottle.hide()
			reset_buttons()
			hotdog.change_state("nice")
			stats.juiciness += (5 * hits[0])
			if stats.juiciness > 100: stats.juiciness = 100
			await get_tree().create_timer(3).timeout
			state_machine.set_state("home"),
		"dress": func (args):
			reset_buttons()
			menu.close()
			state_machine.set_state("dress_select_1"),
		"dress_select_1": func (args):
			hotdog.change_state("dress_select_1")
			reset_buttons()
			handle_right = func (): state_machine.set_state("dress_select_2")
			handle_select = func (): state_machine.set_state("dress_selected", ["dress_1"]),
		"dress_select_2": func (args):
			hotdog.change_state("dress_select_2")
			handle_left = func (): state_machine.set_state("dress_select_1")
			handle_right = func (): state_machine.set_state("dress_select_3")
			handle_select = func (): state_machine.set_state("dress_selected", ["dress_2"]),
		"dress_select_3": func (args):
			hotdog.change_state("dress_select_3")
			reset_buttons()
			handle_left = func (): state_machine.set_state("dress_select_2")
			handle_select = func (): state_machine.set_state("dress_selected", ["dress_3"]),
		"dress_selected": func (args):
			stats.modesty += 30
			if stats.modesty > 100: stats.modesty = 100
			handle_loop = func ():
				state_machine.set_state("home")
			hotdog.change_state(args[0]),
		"end": func (args):
			if game_over: return
			game_over = true
			var text
			var end = $End
			match args[0]:
				"Froze":
					text = $End/Froze
				"Dried":
					text = $End/Dried
				"Jailed":
					text = $End/Jailed
			text.show()
			end.show()
	}, "start")

func _process(delta) -> void:
	if game_over: return

	last_stat_reduction += delta
	if last_stat_reduction > 1:
		last_stat_reduction = 0
		if randi_range(1, 20) % 20 == 1:

			match randi_range(1, 3):
				1:
					stats.warmth -= 10
					if stats.warmth <= 0:
						stats.warmth = 0
						state_machine.set_state("end", ["Froze"])
				2:
					stats.modesty -= 10
					if stats.modesty <= 0:
						stats.modesty = 0
						state_machine.set_state("end", ["Jailed"])
				3:
					stats.juiciness -= 10
					if stats.juiciness <= 0:
						stats.juiciness = 0
						state_machine.set_state("end", ["Dried"])
			print("updating stats", stats)
			stats_control.update_bars(stats)


func _handle_button(name: String) -> void:
	match name:
		"right":
			handle_right.call()
		"left":
			handle_left.call()
		"select":
			handle_select.call()

func handle_menu_select(item: String) -> void:
	match item:
		"home":
			state_machine.set_state("home")
		"stats":
			state_machine.set_state("stats")
		"warm":
			state_machine.set_state("warm")
		"dress":
			state_machine.set_state("dress")
		"juice":
			state_machine.set_state("juice")

func _on_character_looped() -> void:
	handle_loop.call()
