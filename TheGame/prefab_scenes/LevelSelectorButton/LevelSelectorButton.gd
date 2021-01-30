extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var stored_level_name

signal selected(level_name)
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _pressed():
    emit_signal("selected", stored_level_name)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
