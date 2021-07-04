extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var time: float = 0
var prev_secs: int = 0
var size_timer:float = 0

var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	text = format_time()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		active = true

	if !active:
		return

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
	var secs = int(time) - mins * 60
	var millis = int((time - int(time)) * 60)

	if secs > prev_secs:
		prev_secs = secs
		get_font("normal_font").size = 14
		size_timer = .1

	return "\n %02d : %02d : %02d" % [mins, secs, millis]
