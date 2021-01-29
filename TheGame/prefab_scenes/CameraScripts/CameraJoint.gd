extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(int) var speed = 1000
export var max_position = Vector2(1500, 1500)
export var min_position = Vector2(-1500, -1500)

var current_speed = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if Input.is_mouse_button_pressed(3):
        set_global_position(get_global_mouse_position())

    current_speed.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
    current_speed.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

    position += current_speed * speed * delta
    position.x = min(max_position.x, position.x)
    position.x = max(min_position.x, position.x)
    position.y = min(max_position.y, position.y)
    position.y = max(min_position.y, position.y)
    
