class_name StatsControl extends Node2D

@onready var modesty_bar: MeshInstance2D = $Modesty
@onready var juiciness_bar: MeshInstance2D = $Juciness
@onready var warmth_bar: MeshInstance2D = $Warmth

func update_bars(stats):

	update_bar(stats.juiciness, juiciness_bar)
	update_bar(stats.warmth, warmth_bar)
	update_bar(stats.modesty, modesty_bar)
	pass

func update_bar(stat: float, bar: MeshInstance2D):
	var percentage = stat / 100
	var max_size = 91
	var size = round(max_size * percentage)
	var mesh: QuadMesh = bar.mesh
	mesh.size.x = size;

	var left = 63
	var size_diff = floor((91 - size) / 2)
	bar.position.x = left - size_diff
