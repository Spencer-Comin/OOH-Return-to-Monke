extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var time: float = 0
var prev_secs: int = 0
var size_timer:float = 0

# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	text = format_time()
	if size_timer > 0:
		size_timer -= delta
		if size_timer <= 0:
			size_timer = 0
			get_font("normal_font").size = 12
	pass

func format_time():
	var mins = int(time) / 60
	var secs = int(time) - mins
	var millis = int((time - int(time)) * 60)

	if secs > prev_secs:
		prev_secs = secs
		get_font("normal_font").size = 14
		size_timer = .1

	return "\n %02d : %02d : %02d" % [mins, secs, millis]
