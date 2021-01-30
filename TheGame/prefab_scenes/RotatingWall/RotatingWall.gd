extends KinematicBody2D

export(bool) var is_alignable = true
# presistent parameters - to be saved-restored-loaded
var initial_state

export var rotation_speed = 2

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

func _process(delta):
    rotation += delta * rotation_speed