extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var follow_target: KinematicBody2D
var home_point: Vector2
var wander_points
var wander_index: int = 0
var wander_timer: float = 0

var dist_mod = 1.5
export var follow_speed: float
export var follow_distance: float
export var home = false
export var wander_point_count: int = 3
export var pause_time: float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	follow_target = get_node("../Player")
	connect("area_entered", $Area2D, "_on_Area2D_area_entered")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if ! is_instance_valid(follow_target):
		return

	var dir
	
	if !home:
		dir = follow_target.position - position
	else: # replace with some wander AI
		if home_point.distance_to(position) < follow_speed * _delta:
			dir = Vector2.ZERO

			wander_timer += _delta
			if wander_timer > pause_time:
				switch_wander_point()
		else:
			dir = home_point - position
	
	rotation = dir.angle() + PI/2
		
	if(dir.length() > follow_distance):
		move_and_slide(dir.normalized() * (dir.length() * dist_mod + follow_speed))
		$Sprite/Anim.play("run")
	else:
		$Sprite/Anim.play("stand")


func _on_Area2D_area_entered(area):
	if area.is_in_group("Home"):
		home = true
		dist_mod = 0.2
		follow_distance = 0
		_calculate_home(area)
		disconnect("area_entered", $Area2D, "_on_Area2D_area_entered")


func _calculate_home(area):
	var polygon = area.get_node("collider").polygon

	wander_points = []
	for i in range(0, wander_point_count):
		wander_points.append(_calculate_roam_point(polygon))

	home_point = wander_points[0]

func _calculate_roam_point(polygon):
	var triangle_points = Geometry.triangulate_polygon(polygon)
	var triangle = []

	var index = randi()%(triangle_points.size() / 3)
	var i = 0
	while i < 3:
		triangle.append(polygon[index +i])
		i += 1

	var r1 = randf()
	var r2 = randf()

	var n1 = (1 - sqrt(r1))
	var n2 = sqrt(r1) * (1 - r2)
	var n3 = r2 * sqrt(r1)

	return (n1 * triangle[0]) + (n2 * triangle[1]) + (n3 * triangle[2])

func switch_wander_point():
	print("wander point altered")
	wander_index += 1;
	if wander_index >= wander_points.size():
		wander_index = 0
	home_point = wander_points[wander_index]

	wander_timer = 0
