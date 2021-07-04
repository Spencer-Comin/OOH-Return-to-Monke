extends KinematicBody2D


var player_attraction = 15
var velocity = Vector2.ZERO
export var alive_time = 0
var air_friction = 0.01


func _ready():
	$AnimationPlayer.play("spin")

func _physics_process(delta):
	alive_time += delta
	var acceleration = ($"../Player/ThrowPoint".global_position - position).normalized() * player_attraction
	velocity += acceleration
	velocity *= 1 - air_friction
	# position += velocity
	move_and_slide(velocity)


func _on_VisibilityNotifier2D_screen_exited():
	pass
	#queue_free()


func _on_Banan_body_entered(body):
	if body.is_in_group("Walls"):
		queue_free()
