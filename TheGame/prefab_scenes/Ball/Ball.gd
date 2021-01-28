extends RigidBody2D

onready var impulse_selector = $ImpulseSelector
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var is_hovered = false
#var is_launched = false
var is_active_mode = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_input()

func process_input():
	pass
#	if Input.is_action_just_pressed("right_click") \
#		and not is_active_mode \
#		and not impulse_selector.is_controlled \
#		and impulse_selector.is_input_provided:
#			initial_launch()
			

func can_launch():
	return impulse_selector.is_input_provided \
		and not impulse_selector.is_controlled;
	

func go_to_sleep_mode():
	sleeping = true

func go_to_actibe_mode():
	impulse_selector.is_input_disabled = true
	impulse_selector.visible = false
	sleeping = false


func initial_launch():
	go_to_actibe_mode()
	var initial_impulse = impulse_selector.get_impulse()
	apply_central_impulse(initial_impulse)
	
func on_activation_zone_activated(activation_zone):
	if activation_zone.is_in_group("VictoryZone"):
		go_to_sleep_mode()

func _on_InteractionArea_mouse_entered():
	is_hovered = true

func _on_InteractionArea_mouse_exited():
	is_hovered = false


func _on_InteractionArea_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		print("click detected")
	
	if not impulse_selector.is_input_disabled \
	and not impulse_selector.is_controlled \
	and event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		impulse_selector.is_controlled = true
		impulse_selector.is_just_received_control_command = true
