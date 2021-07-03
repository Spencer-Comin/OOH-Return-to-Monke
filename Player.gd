extends Node2D

export (PackedScene) var Banan

var velocity
export var speed = 2
var screen_size
var throwing = false
var can_throw = true
var cooldown_time = 4


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$KinematicBody2D/AnimatedSprite.animation = "stop"
	

func start(x, y):
	position.x = x
	position.y = y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		velocity.x = 1
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -1
	if Input.is_action_pressed("ui_up"):
		velocity.y = -1
	elif Input.is_action_pressed("ui_down"):
		velocity.y = 1

	if Input.is_key_pressed(KEY_SPACE) and can_throw:
		throw()
	elif velocity.length() > 0 and not throwing:
		$KinematicBody2D.rotation = velocity.angle() + PI/2
		velocity = velocity.normalized() * speed
		$KinematicBody2D.move_and_collide(velocity)
		position = $KinematicBody2D.position
		$KinematicBody2D/AnimatedSprite.play("run")


func throw():
	print("throwing banan")
	throwing = true
	can_throw = false
	$ThrowCooldown.start(cooldown_time)
	print("starting cooldown")
	$KinematicBody2D/AnimatedSprite.play("throw")
	var b = Banan.instance()
	owner.add_child(b)
	b.transform = $KinematicBody2D/ThrowPoint.global_transform
	var angle = $KinematicBody2D.rotation - PI/2
	b.velocity = Vector2(cos(angle), sin(angle)) * b.speed
	b.show()


func _on_AnimatedSprite_animation_finished():
	$KinematicBody2D/AnimatedSprite.animation = "stop"
	$KinematicBody2D/AnimatedSprite.stop()
	throwing = false


func _on_ThrowCooldown_timeout():
	can_throw = true
	print("cooldown done")
