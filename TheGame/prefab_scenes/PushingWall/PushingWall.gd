extends Node2D

export(bool) var is_alignable = true
# presistent parameters - to be saved-restored-loaded
var initial_state
onready var kinematic_body = $KinematicBody2D
onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
    animation_player.stop()
    pass # Replace with function body.

func get_item_ui_data():
    return $ItemUIData
    

func can_launch():
    return true

func initial_launch():
    save_initial_state()
    animation_player.play("push")

func save_initial_state():
    initial_state = {
        "initial_rotation": rotation,
        "kinematic_body_pos": kinematic_body.position,
        "is_animation_playing": false
    }
    
func load_saved_state():
    if initial_state:
        load_state(initial_state)
    else:
        print("called load_saved_state without saved initial_state")

func load_state(state):
    rotation = initial_state["initial_rotation"]
    
    kinematic_body.position = initial_state["kinematic_body_pos"]
    
    if initial_state["is_animation_playing"]:
        animation_player.play()
    else:
        animation_player.stop()

func _process(delta):
    pass
