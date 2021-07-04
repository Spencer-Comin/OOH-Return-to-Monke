extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var total: int


# Called when the node enters the scene tree for the first time.
func _ready():
	total = count_humans()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	text = "\n " + str(total - count_humans()) + " / " + str(total) + " Enlightened"
	text += "\n " + count_home() + " / " + str(total) + " rescued"
	pass


func count_humans():
	return get_tree().get_nodes_in_group("humans").size()

func count_home():
	var n = 0
	for x in get_tree().get_nodes_in_group("small monkeys"):
		if x.home:
			n += 1
	
	return str(n)
