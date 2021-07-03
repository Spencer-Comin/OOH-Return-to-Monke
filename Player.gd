extends KinematicBody2D

export (PackedScene) var Banan

var velocity
export var speed = 2
export var throw_speed = 15
var screen_size
var throwing = false
var can_throw = true
var cooldown_time = 2
var catch_obj


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$Monke/AnimationPlayer.play("sit")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var animation = "sit"
	
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		velocity.x = 1
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -1
	if Input.is_action_pressed("ui_up"):
		velocity.y = -1
	elif Input.is_action_pressed("ui_down"):
		velocity.y = 1

	if Input.is_action_just_pressed("throw") and can_throw:
		throwing = true
		can_throw = false
		$ThrowCooldown.start(cooldown_time)
		$Monke/AnimationPlayer.play("throw")
	if velocity.length() > 0:
		rotation = velocity.angle() + PI/2
		velocity = velocity.normalized() * speed
		move_and_collide(velocity)
		if not throwing:
			$Monke/AnimationPlayer.play("run")


func throw():
	var b = Banan.instance()
	owner.add_child(b)
	var angle = rotation - PI/2
	b.velocity = Vector2(cos(angle), sin(angle)) * throw_speed
	b.transform = $ThrowPoint.global_transform


func _on_ThrowCooldown_timeout():
	can_throw = true
	print("cooldown done")


func _on_AnimationPlayer_animation_finished(anim_name):
	throwing = false


func _on_CatchArea_body_entered(body):
	if body.is_in_group("Banan") and body.alive_time > 1:
		$Monke/AnimationPlayer.play("catch")
		body.velocity = Vector2.ZERO
		catch_obj = body
		

func remove_catch_obj():
	catch_obj.queue_free()
