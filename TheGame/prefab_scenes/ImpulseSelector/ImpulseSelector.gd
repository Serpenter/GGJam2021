extends Node2D

onready var line = $Line2D
onready var sprite = $Sprite

export var max_angle = 0
export var min_angle = 360

export var max_length = 230
export var min_length= 30

export var is_input_disabled = false
export var is_input_provided = false

var is_controlled = false
var is_just_received_control_command = false

var initial_state = null

onready var parent_ball = get_parent() 

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if is_controlled:
        process_mouse_input()

func load_saved_state():
    if initial_state:
        load_state(initial_state)
    else:
        print("called load_saved_state without saved initial_state")

func save_initial_state():
    initial_state = {
        "is_input_disabled":is_input_disabled,
        "is_input_provided":is_input_provided, 
        "is_controlled":false, 
        "is_just_received_control_command":false, 
        "end_position":line.points[1],
        "visible": visible
    }
    
func load_state(state):
    is_input_disabled = state["is_input_disabled"]
    is_input_provided = state["is_input_provided"]
    is_controlled = state["is_controlled"]
    is_just_received_control_command = state["is_just_received_control_command"]
    visible = state["visible"]
    
    line.points[1] = state["end_position"]
    sprite.position = state["end_position"]
    sprite.rotation = state["end_position"].angle() + 0.5 * PI

func set_default_initial_impulse():
    var angle = 0.5 * (max_angle + min_angle) * PI / 180
    var end_position = Vector2(min_length, 0).rotated(angle)
    set_end_position(end_position)

func get_impulse():
    if not is_input_provided:
        print("Getting impulse without input")
        
    var impulse =  line.points[1]
    
    if parent_ball:
        impulse = impulse.rotated(parent_ball.rotation)

    return impulse
    

func process_mouse_input():
    var mouse_pos = get_global_mouse_position()
    update_by_position(mouse_pos)
    
    if Input.is_action_just_pressed("left_click") \
        and not is_just_received_control_command:
        is_input_provided = true
        is_controlled = false
        
    is_just_received_control_command = false
    
func set_end_position(end_position):
    if parent_ball:
        end_position = end_position.rotated(-parent_ball.rotation)
    line.points[1] = end_position
    sprite.position = end_position
    sprite.rotation = end_position.angle() + 0.5 * PI
    
func update_by_position(target_position):
    var relative_position = target_position - global_transform.origin
    update_by_relative_position(relative_position)
    
    
func update_by_relative_position(relative_position):
    var new_length = min(relative_position.length(), max_length)
    new_length = max(new_length, min_length)
    var new_angle = relative_position.angle()
    new_angle = angle_to_allowed_angle(new_angle)

#	if not is_angle_allowed(new_angle):
#		new_angle = line.points[1].angle()

    var new_end_position = Vector2(new_length, 0).rotated(new_angle)
#	print(new_end_position)
    set_end_position(new_end_position)
    

func is_angle_allowed_rad(angle_rad):
    var angle_deg = angle_rad * 180 /  PI
    return is_angle_allowed_deg(angle_deg)
    
func is_angle_allowed_deg(angle_deg):
    if angle_deg < 0:
        angle_deg += 360

    return angle_deg >= min_angle and angle_deg <= max_angle
    
func angle_to_allowed_angle(angle_rad):

    var angle_deg= angle_rad * 180 /  PI
    
    if angle_deg < 0:
        angle_deg += 360
        
    if is_angle_allowed_deg(angle_deg):
        return angle_rad
        
    var min_diff = min(abs(min_angle - angle_deg), abs(360 - abs(min_angle - angle_deg)))
    var max_diff = min(abs(max_angle - angle_deg), abs(360 - abs(max_angle - angle_deg)))
    
    if max_diff < min_diff:
        angle_deg = max_angle
    else:
         angle_deg = min_angle
#	print(angle_degrees)
#	print(angle_degrees)
    var allowed_angle_rad = angle_deg * PI / 180
#	print(allowed_angle_rad)
    return allowed_angle_rad
