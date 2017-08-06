extends Sprite

var status = "on"
export var timer = 4
var aux_timer = timer

var area = null
var tex_on = load("res://enemies/spike/spike_on.tex")
var tex_off = load("res://enemies/spike/spike_off.tex")
var overlap = null

func _ready():
	set_process(true)
	set_texture(tex_on)
	area = get_node("Area2D")
	
func _process(delta):
	if status == "on":
		
		overlap = area.get_overlapping_bodies()
		for i in overlap:
			if i.is_in_group("players"):
				get_tree().change_scene("res://scenes/game_over.tscn")
		
		aux_timer -= delta
		if aux_timer <= 0:
			status = "off"
			aux_timer = timer
			set_texture(tex_off)
	elif status == "off":
		aux_timer -= delta
		if aux_timer <= 0:
			status = "on"
			aux_timer = timer
			set_texture(tex_on)