extends KinematicBody2D

export var player_speed = 200
var velocity = Vector2()

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	
	velocity.x = 0
	velocity.y = 0
	get_node("AnimatedSprite/AnimationPlayer").play("idle")
	
	if (Input.is_action_pressed("walk_left")):
		velocity.x = -player_speed
		get_node("AnimatedSprite/AnimationPlayer").play("left")
	elif (Input.is_action_pressed("walk_right")):
		velocity.x = player_speed
		
	if (Input.is_action_pressed("walk_up")):
		velocity.y = -player_speed
	elif (Input.is_action_pressed("walk_down")):
		velocity.y = player_speed
		get_node("AnimatedSprite/AnimationPlayer").play("down")
		
	if (Input.is_action_pressed("walk_down") and Input.is_action_pressed("walk_right")):
		get_node("AnimatedSprite/AnimationPlayer").play("down_right")

	var motion = velocity * delta
	motion = move(motion)
	
	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		move(motion)