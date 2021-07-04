extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var smol_monke: PackedScene
export var speed: int
export var roam_distance: float = 50
export var pause_time: float

var nav_points
var target_point
var nav_index: int = 0

var timer: float = 0
var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	nav_points = []
	nav_points.append(position + (Vector2.UP.rotated(rotation)) * roam_distance)
	nav_points.append(position - (Vector2.UP.rotated(rotation)) * roam_distance)
	target_point = nav_points[0]
	rotation = (target_point - position).angle()
	velocity = (target_point - position).normalized() * speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if position.distance_to(target_point) >= speed * delta:
		move_and_slide(velocity)
	if position.distance_to(target_point) < speed * delta:
		if timer == 0:
			$Sprite/Anim.play("stand")
		timer += delta
		if timer > pause_time:
			switch_target_point()


func switch_target_point():
	nav_index += 1
	if nav_index >= nav_points.size():
		nav_index = 0
	
	target_point = nav_points[nav_index]
	rotation = (target_point - position).angle() - PI / 2
	velocity = (target_point - position).normalized() * speed

	timer = 0
	$Sprite/Anim.play("walk")


func _on_hitbox_body_entered(body):
	if body.is_in_group("Banan"):
		var m = smol_monke.instance()
		owner.add_child(m)
		m.transform = global_transform
		# var vel = body.velocity
		# var diff = body.position - position
		# body.velocity = vel.reflect(diff) * 2
		body.alive_time += 1

		queue_free()
