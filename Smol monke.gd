extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var follow_target: KinematicBody2D
export var follow_speed: float
export var follow_distance: float

# Called when the node enters the scene tree for the first time.
func _ready():
	follow_target = get_node("../Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if ! is_instance_valid(follow_target):
		return

	var dir = follow_target.position - position
	rotation = dir.angle() + PI/2
	if(dir.length() > follow_distance):
		move_and_slide(dir.normalized() * (dir.length() * 1.5 + follow_speed))
		$Sprite/Anim.play("run")
	else:
		$Sprite/Anim.play("stand")

