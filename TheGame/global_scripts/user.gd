extends Node

        
        
enum UserControl {
    NONE_ON_START = 0,
    NONE_AFTER_LAUNCH = 1,
    IMPULSE_SELECTOR = 2,
    OBSTACLE_PLACEMENT = 3,
}

var disable_tile_selection = false

var current_control = UserControl.NONE_ON_START

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
