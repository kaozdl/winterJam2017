extends KinematicBody2D

export var player_speed = 2000
var input_states = preload('res://utils/input_states.gd')
var velocity = Vector2()
var fuAttackArea = null
var fdAttackArea = null
var on_camera = null
var enemies_on_camera = []
var enemies_on_area = []
var FacingDirection 
var FutureFacingDirection
var PreviousFacingDirection
var attack_btn = input_states.new('attack_btn') 
# DECOY 
var aggro_btn = input_states.new("aggro_btn")
var decoy = null
var decoy_cooldown = 8
var decoy_aux_cooldown = decoy_cooldown
var enable_decoy = true
# MOVE
var left_btn = input_states.new("walk_left")
var right_btn = input_states.new("walk_right")
var down_btn = input_states.new("walk_down")
var up_btn = input_states.new("walk_up")

func attack(target_area):
	enemies_on_area = target_area.get_overlapping_bodies()
	for enemy in enemies_on_area:
		if enemy.is_in_group("enemies"):
			enemy.disable()

func enable_bots(enemies_on_camera):
	for enemy in enemies_on_camera:
		if enemy.is_in_group("enemies"):
			enemy.activate()
func _ready():
	FacingDirection = "up"
	fuAttackArea = get_node("FuAttackArea")
	fdAttackArea = get_node("FdAttackArea")
	set_fixed_process(true)
	get_node("AnimatedSprite/AnimationPlayer").play("idle")

func _fixed_process(delta):
	on_camera = get_node("Camera2D/On_camera")
	enemies_on_camera = on_camera.get_overlapping_bodies()
	enable_bots(enemies_on_camera)
	
	PreviousFacingDirection = FacingDirection
	FacingDirection = FutureFacingDirection
		
	var attack_area
	if FacingDirection == "up":
		attack_area = fuAttackArea
	else:
		attack_area = fdAttackArea
	
	if attack_btn.check() == 1: # JUST PRESSED
		attack(attack_area)
	
	velocity.x = 0
	velocity.y = 0
	
	if aggro_btn.check() == 1 and enable_decoy:
		decoy = get_node('../decoy')
		decoy.set_global_pos(get_global_pos())
		enable_decoy = false
		
	if not enable_decoy:
		decoy_aux_cooldown -= delta
		if decoy_aux_cooldown <= 0:
			decoy_aux_cooldown = decoy_cooldown
			enable_decoy = true
	
	# play animation
	if down_btn.check() == 1  \
			and (not Input.is_action_pressed("walk_left") \
			or not Input.is_action_pressed("walk_right")):
		get_node("AnimatedSprite/AnimationPlayer").play("down")
	elif up_btn.check() == 1  \
			and (not Input.is_action_pressed("walk_left") \
			or not Input.is_action_pressed("walk_right")):
		get_node("AnimatedSprite/AnimationPlayer").play("up")
	elif left_btn.check() == 1:
		get_node("AnimatedSprite/AnimationPlayer").play("left")
	elif right_btn.check() == 1:
		get_node("AnimatedSprite/AnimationPlayer").play("right")
	elif not Input.is_action_pressed("walk_right") \
			and not Input.is_action_pressed("walk_left") \
			and not Input.is_action_pressed("walk_down") \
			and not Input.is_action_pressed("walk_up"):
		get_node("AnimatedSprite/AnimationPlayer").play("idle")
	
	if (Input.is_action_pressed("walk_left")):
		velocity.x = -player_speed
	elif (Input.is_action_pressed("walk_right")):
		velocity.x = player_speed
		
	if (Input.is_action_pressed("walk_up")):
		FutureFacingDirection = "up"
		velocity.y = -player_speed
	elif (Input.is_action_pressed("walk_down")):
		velocity.y = player_speed
		FutureFacingDirection = "down"

	var motion = velocity * delta
	motion = move(motion)
	
	
	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		move(motion)