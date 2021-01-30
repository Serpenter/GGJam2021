extends Node2D


onready var interaction_area = $InteractionArea
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var light = $Lights/Light2D

export var forcefield_name = "green"

export var activation_groups = ["Ball"]

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
#    area_sprite.modulate = Forcefields.get_forcefield_color(forcefield_name)
    var color  = Forcefields.get_forcefield_color(forcefield_name)
    sprite.modulate = color
    light.color = color
    animation_player.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_InteractionArea_body_entered(body):
    for group_name in activation_groups:
        if body.is_in_group(group_name) and body.has_method("on_forcefield_panel_activation"):
            body.on_forcefield_panel_activation(self)
