extends RigidBody2D


var player_attraction = 0.5
var velocity = Vector2.ZERO
export var alive_time = 0


func _ready():
	$AnimationPlayer.play("spin")

func _physics_process(delta):
	alive_time += delta
	var acceleration = ($"../Player/ThrowPoint".global_position - position).normalized() * player_attraction
	velocity += acceleration
	position += velocity


func _on_VisibilityNotifier2D_screen_exited():
	pass
	#queue_free()
