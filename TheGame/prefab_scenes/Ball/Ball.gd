extends RigidBody2D

onready var impulse_selector = $ImpulseSelector
var is_hovered = false
var is_active_mode = false

export var min_impulse_angle = 0
export var max_impulse_angle = 360

export var min_impulse_length = 30
export var max_impulse_length = 230


var initial_state = null

onready var face_normal_sprite = $FaceNormalSprite
onready var face_sad_sprite = $FaceSadSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	face_normal_sprite.visible = true
	face_sad_sprite.visible = false
	impulse_selector.min_angle = min_impulse_angle
	impulse_selector.max_angle = max_impulse_angle
	impulse_selector.min_length = min_impulse_length
	impulse_selector.max_length = max_impulse_length
	impulse_selector.set_default_initial_impulse()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_input()

func process_input():
	pass


func can_launch():
	return impulse_selector.is_input_provided \
		and not impulse_selector.is_controlled;
	

func go_to_sleep_mode():
	sleeping = true

func go_to_actibe_mode():
	impulse_selector.is_input_disabled = true
	impulse_selector.visible = false
	sleeping = false

func load_saved_state():
	if initial_state:
		load_state(initial_state)
	else:
		print("called load_saved_state without saved initial_state")

func save_initial_state():
	initial_state = {
	"position": position,
	"rotation": rotation,
	"is_active_mode": is_active_mode,
	"is_hovered": false,
	"sleeping": sleeping,
	"applied_force": applied_force,
	"applied_torque": applied_torque,
	"inertia": inertia
}

func load_state(state):
	position = state["position"]
	rotation = state["rotation"]
	is_active_mode = state["is_active_mode"]
	is_hovered = state["is_hovered"]
	sleeping = state["sleeping"]
	applied_force = state["applied_force"]
	applied_torque = state["applied_torque"]
	inertia = state["inertia"]

func initial_launch():
	go_to_actibe_mode()
	var initial_impulse = impulse_selector.get_impulse()
	apply_central_impulse(initial_impulse)
	
func on_activation_zone_activated(activation_zone):
	if activation_zone.is_in_group("VictoryZone"):
#		go_to_sleep_mode()
		pass

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
