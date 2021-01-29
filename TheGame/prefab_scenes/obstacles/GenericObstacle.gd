extends Node2D

export(bool) var is_alignable = true
# presistent parameters - to be saved-restored-loaded
var initial_state

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func get_item_ui_data():
    return $ItemUIData

func save_initial_state():
    initial_state = {
        "initial_rotation": rotation
    }

func load_state(state):
    rotation = initial_state["initial_rotation"]
