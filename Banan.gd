extends Node2D

export var velocity = Vector2.ZERO
const speed = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	print("banan created")
	self.hide()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity
