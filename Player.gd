extends KinematicBody2D

export (PackedScene) var Banan

var velocity = Vector2.ZERO
export var speed = 2
export var throw_speed = 15
var screen_size
var throwing = false
var can_throw = true
var catching = false
var cooldown_time = 5
var catch_obj

var b = true


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$Monke/AnimationPlayer.play("sit")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var animation = "sit"
	
	# velocity = Vector2.ZERO
	var vel = Vector2.ZERO
	
	if !catching and !throwing:
		if Input.is_action_pressed("ui_right"):
			vel.x = 1
		elif Input.is_action_pressed("ui_left"):
			vel.x = -1
		if Input.is_action_pressed("ui_up"):
			vel.y = -1
		elif Input.is_action_pressed("ui_down"):
			vel.y = 1

	if Input.is_action_just_pressed("throw") and can_throw:
		throwing = true
		can_throw = false
		$ThrowCooldown.start(cooldown_time)
		$Monke/AnimationPlayer.play("throw")
	# if vel.length() > 0:
	vel = vel.normalized() * speed
	velocity = velocity.linear_interpolate(vel, 0.2)

	rotation = velocity.angle() + PI/2
	move_and_slide(velocity)
	if not throwing and vel.length() > 0:
		$Monke/AnimationPlayer.play("run")


func throw():
	var b = Banan.instance()
	owner.add_child(b)
	var angle = rotation - PI/2
	b.velocity = Vector2(cos(angle), sin(angle)) * throw_speed
	b.transform = $ThrowPoint.global_transform
	b = true


func _on_ThrowCooldown_timeout():
	remove_catch_obj()
	print("cooldown done")


func _on_AnimationPlayer_animation_finished(anim_name):
	throwing = false


func _on_CatchArea_body_entered(body):
	if body.is_in_group("Banan"):# and body.alive_time > .1:
		if b:
			b = false
			return
		$Monke/AnimationPlayer.play("catch")
		body.velocity = Vector2.ZERO
		catch_obj = body
		catching = true
		

func remove_catch_obj():
	if !is_instance_valid(catch_obj):
		return
	catch_obj.queue_free()
	catching = false
	can_throw = true
	b = true
