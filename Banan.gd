extends Area2D

var speed = 5

func _ready():
	$AnimationPlayer.play("spin")

func _physics_process(delta):
	position -= transform.y * speed

func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
