extends StaticBody2D

onready var sprite = $Sprite

export var forcefield_name = "green"


# Called when the node enters the scene tree for the first time.
func _ready():
    sprite.modulate = Forcefields.get_forcefield_color(forcefield_name)
    var layer = Forcefields.get_forcefield_layer(forcefield_name)
    set_collision_layer_bit(layer, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
