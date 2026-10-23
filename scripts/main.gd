extends Node2D

enum STATE { HOME, MENU, STATS, WARM, DRESS, JUICE }

@onready var menu: Menu = $Menu
@onready var hotdog: HotDog = $Character
@onready var stats_control: StatsControl = $Stats

var state_machine = {
	current = STATE.HOME
}

var stats = {
	warmth = 100,
	modesty = 100,
	juiciness = 100
}

var last_stat_reduction = 0

func _process(delta) -> void:
	# randomly reduce a stat every second
	last_stat_reduction += delta
	if last_stat_reduction > 1:
		last_stat_reduction = 0
		if randi() % 20 == 1:
			# pick a random stat
			match randi_range(1, 3):
				1:
					stats.warmth -= 1
				2: 
					stats.modesty -= 1
				3:
					stats.juiciness -= 1

# btn handlers
func _handle_button(name: String) -> void:
	match state_machine.current:
		STATE.HOME:
			if name == "select":
				state_machine.current = STATE.MENU
				menu.open()
		STATE.STATS:
			if name == "select":
				state_machine.current = STATE.MENU
				menu.open()
		STATE.MENU:
			menu.handle_button(name)
			
func handle_menu_select(item: String) -> void:
	match item:
		"home":
			state_machine.current = STATE.HOME
			menu.close()
		"stats":
			state_machine.current = STATE.STATS
			menu.close()
		"warm":
			state_machine.current = STATE.WARM
			menu.close()
			hotdog.change_state("warm")
			await get_tree().create_timer(5).timeout
			state_machine.current = STATE.HOME
			hotdog.change_state("idle")
		"dress":
			state_machine.current = STATE.DRESS
		"juice":
			state_machine.current = STATE.JUICE
