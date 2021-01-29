extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var forcefield_dict = {
        "green":
        {
            "color": Color.green,
            "layer":3
        },
        "aqua":
        {
            "color": Color.aqua ,
            "layer":4
        },
        "violet":
        {
            "color": Color.violet,
            "layer":5
        },
        "red":
        {
            "color": Color.red,
            "layer":6
        }
}


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.
    
func is_forcefield_exists(forcefield_name):
    return forcefield_dict.has(forcefield_name)
    
func get_forcefield_layer(forcefield_name):
    return forcefield_dict.get(forcefield_name).get("layer")

func get_forcefield_color(forcefield_name):
    return forcefield_dict.get(forcefield_name).get("color")
    
func get_all_forcefield_layers():

    var layers = []

    for value in forcefield_dict.values():
        layers.append(value["layer"])
    
    return layers

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
