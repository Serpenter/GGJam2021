extends KinematicBody2D

export(bool) var is_alignable = true
# presistent parameters - to be saved-restored-loaded
var initial_state

var is_rotating = false

export var rotation_speed = 2

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func get_item_ui_data():
    return $ItemUIData
    
func can_launch():
    return true
    
func initial_launch():
    save_initial_state()
    is_rotating = true

    
func load_saved_state():
    if initial_state:
        load_state(initial_state)
    else:
        print("called load_saved_state without saved initial_state")

func save_initial_state():
    initial_state = {
        "initial_rotation": rotation,
        "is_rotating": is_rotating
    }

func load_state(state):
    rotation = initial_state["initial_rotation"]
    is_rotating = initial_state["is_rotating"]

func _process(delta):
    if is_rotating:
        rotation += delta * rotation_speed
