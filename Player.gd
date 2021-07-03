extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity
export var speed = 3
var screen_size
var throwing = false


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$KinematicBody2D/AnimatedSprite.stop()


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

	if Input.is_key_pressed(KEY_SPACE):
		$KinematicBody2D/AnimatedSprite.connect("animation_finished", self, "_on_animation_finished")
		$KinematicBody2D/AnimatedSprite.play("throw")
		throwing = true
	elif velocity.length() > 0 and not throwing:
		$KinematicBody2D.rotation = velocity.angle() + deg2rad(90) 
		velocity = velocity.normalized() * speed
		$KinematicBody2D.move_and_collide(velocity)
		$KinematicBody2D/AnimatedSprite.play("run")
	else:
		$KinematicBody2D/AnimatedSprite.connect("animation_finished", self, "_on_animation_finished")


func _on_animation_finished():
	$KinematicBody2D/AnimatedSprite.animation = "stop"
	$KinematicBody2D/AnimatedSprite.stop()
	throwing = false
