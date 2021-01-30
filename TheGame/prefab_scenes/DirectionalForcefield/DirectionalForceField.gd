extends StaticBody2D

onready var sprite = $Sprite
onready var light = $Light2D
export var forcefield_name = "directional"
var layer = 7
export(bool) var is_alignable = true
# presistent parameters - to be saved-restored-loaded
var initial_state

func get_item_ui_data():
    return $ItemUIData

func save_initial_state():
    initial_state = {
        "initial_rotation": rotation
    }

func load_state(state):
    rotation = initial_state["initial_rotation"]


# Called when the node enters the scene tree for the first time.
func _ready():   
    var color = Forcefields.get_forcefield_color(forcefield_name)
    layer = Forcefields.get_forcefield_layer(forcefield_name)
    set_collision_layer_bit(layer, true)
    sprite.modulate = color
    light.color = color

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_EnteringArea_body_entered(body):
    body.set_collision_mask_bit(layer, false)
    pass # Replace with function body.


func _on_ExitingArea_body_exited(body):
    body.set_collision_mask_bit(layer, true)
    pass # Replace with function body.
