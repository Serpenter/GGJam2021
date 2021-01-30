extends Camera2D
var zoom_pos


export var max_zoom = Vector2(3.0, 3.0)
export var min_zoom = Vector2(0.6, 0.6)
export var zoom_step = Vector2(0.1, 0.1)

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func _input(event):
    if event is InputEventMouseButton:
        if event.is_pressed():
            # zoom in
            if event.button_index == BUTTON_WHEEL_DOWN:
                zoom += zoom_step
                zoom = max_zoom if max_zoom.length_squared() < zoom.length_squared() else zoom
                zoom_pos = get_global_mouse_position()

            # zoom out
            elif event.button_index == BUTTON_WHEEL_UP:
                zoom -= zoom_step
                zoom = min_zoom if min_zoom.length_squared() > zoom.length_squared() else zoom
                zoom_pos = get_global_mouse_position()
            
