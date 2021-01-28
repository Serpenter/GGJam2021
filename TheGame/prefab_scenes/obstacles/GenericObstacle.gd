extends Node2D

# presistent parameters - to be saved-restored-loaded
var initial_rotation

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func get_item_ui_data():
    return $ItemUIData

