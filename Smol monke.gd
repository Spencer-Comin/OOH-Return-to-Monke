extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var follow_target: KinematicBody2D
export var follow_speed: float
export var follow_distance: float
export var following = true

# Called when the node enters the scene tree for the first time.
func _ready():
	follow_target = get_node("../Player")
	connect("area_entered", $Area2D, "_on_Area2D_area_entered")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if ! is_instance_valid(follow_target):
		return

	var dir
	
	if following:
		dir = follow_target.position - position
	else:
		dir = Vector2.ZERO # replace with some wander AI
	
	rotation = dir.angle() + PI/2
		
	if(dir.length() > follow_distance):
		move_and_slide(dir.normalized() * (dir.length() * 1.5 + follow_speed))
		$Sprite/Anim.play("run")
	else:
		$Sprite/Anim.play("stand")


func _on_Area2D_area_entered(area):
	if area.is_in_group("Home"):
		print(self, " home")
		following = false
		disconnect("area_entered", $Area2D, "_on_Area2D_area_entered")
