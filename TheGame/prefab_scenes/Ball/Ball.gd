extends RigidBody2D

onready var impulse_selector = $ImpulseSelector
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var is_hovered = false
var is_launched = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_input()

func process_input():
	if Input.is_action_just_pressed("right_click") \
		and not is_launched \
		and not impulse_selector.is_controlled \
		and impulse_selector.is_input_provided:
			initial_launch()
			
			
func initial_launch():
	is_launched = true
	impulse_selector.is_input_disabled = true
	impulse_selector.visible = false
	sleeping = false
	var initial_impulse = impulse_selector.get_impulse()
	apply_central_impulse(initial_impulse)

func _on_InteractionArea_mouse_entered():
	is_hovered = true


func _on_InteractionArea_mouse_exited():
	is_hovered = false


func _on_InteractionArea_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		print("click detected")
	if not impulse_selector.is_input_disabled \
	and not impulse_selector.is_controlled \
	and event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		impulse_selector.is_controlled = true
		impulse_selector.is_just_received_control_command = true
