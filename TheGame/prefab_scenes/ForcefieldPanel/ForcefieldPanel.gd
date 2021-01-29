extends Node2D


onready var interaction_area = $InteractionArea
onready var area_sprite = $AreaSprite
onready var button_sprite = $ButtonSprite

var color = Color(0, 0.8, 1)
var forcefield_collision_layer = 3

export var activation_groups = ["Ball"]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_InteractionArea_body_entered(body):
	for group_name in activation_groups:
		if body.is_in_group(group_name) and body.has_method("on_forcefield_panel_activation"):
			body.on_forcefield_panel_activation(self)
