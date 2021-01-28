extends Node2D


onready var interaction_area = $InteractionArea
onready var area_sprite = $AreaSprite
onready var button_sprite = $ButtonSprite

export var is_activated = false

var deactivated_color = Color(1,0,0)
var activated_colot = Color(0,1,0)

export var activation_groups = ["Ball"]

var initial_state = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func load_saved_state():
	if initial_state:
		load_state(initial_state)
	else:
		print("called load_saved_state without saved initial_state")

func save_initial_state():
	initial_state = {
	"position": position,
	"rotation": rotation,
	"is_activated": is_activated
}

func load_state(state):
	position = state["position"]
	rotation = state["rotation"]
	if state["is_activated"]:
		activate()
	else:
		deactivate()

func deactivate():
	is_activated = false
	area_sprite.modulate = deactivated_color
	button_sprite.modulate = deactivated_color

func activate():
	is_activated = true
	area_sprite.modulate = activated_colot
	button_sprite.modulate = activated_colot
	get_tree().call_group("ActivationZoneSubscriber", "on_zone_activated", self)



func _on_InteractionArea_body_entered(body):
	pass # Replace with function body.


func _on_InteractionArea_body_exited(body):
	for group_name in activation_groups:
		if body.is_in_group(group_name):
			activate()
			if body.has_method("on_activation_zone_activated"):
				body.on_activation_zone_activated(self)

			return
