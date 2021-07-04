extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var smol_monke: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_hitbox_body_entered(body):
	if body.is_in_group("Banan"):
		var m = smol_monke.instance()
		owner.add_child(m)
		m.transform = global_transform

		var vel = body.velocity
		var diff = body.position - position
		body.velocity = vel.reflect(diff) * 2
		body.alive_time += 1

		queue_free()
