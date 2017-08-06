extends Sprite

var status = "on"
export var timer = 4
var aux_timer = timer

var area = null
var tex_on = load("res://enemies/spike/spike_on.tex")
var tex_off = load("res://enemies/spike/spike_off.tex")

func _ready():
	set_process(true)
	set_texture(tex_on)
	area = get_node("Area2D")
	
func _process(delta):
	if status == "on":
		aux_timer -= delta
		if aux_timer <= 0:
			status = "off"
			area.set_enable_monitoring(false)
			aux_timer = timer
			set_texture(tex_off)
	elif status == "off":
		aux_timer -= delta
		if aux_timer <= 0:
			status = "on"
			area.set_enable_monitoring(true)
			aux_timer = timer
			set_texture(tex_on)