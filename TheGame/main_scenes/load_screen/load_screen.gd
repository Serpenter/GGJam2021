extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var offset = Vector2(0, 200)
export(PackedScene) var cat

var last_progres = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

func set_progress(progress):
    var direction = offset.rotated(progress * TAU)
    var newcatmark = cat.instance()
    $pivot.add_child(newcatmark)
    newcatmark.position = direction
