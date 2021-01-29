extends Node2D

onready var ball_prefab = preload("res://prefab_scenes/CatFood/CatFood.tscn")

onready var line = $Line2D
onready var arrow_sprite = $ArrowSprite
onready var sprite = $Sprite
onready var ball_spawn = $BallSpawn
onready var current_ball = null
onready var ball_spawn_timer = $BallSpawnTimer
onready var ball_launch_timer = $BallLaunchTimer
onready var label = $Labels/Label

export var min_angle = 0
export var max_angle = 360

export var min_length= 0
export var max_length = 250


export var is_input_disabled = true
export var is_input_provided = true
export var infinite_ball_spawn = false

export var max_balls_number = 1
var spawned_balls = 0
var launched_balls = 0
var is_launched = false

var is_hovered = false

var is_controlled = false
var is_just_received_control_command = false

var initial_state = null
export var default_end_pos = Vector2(0, 0)
var default_ball_spawn_pos = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
    label.visible = false
    sprite.visible = false
    update_label()
    set_end_position(default_end_pos)
    spawn_ball()
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if is_controlled:
        process_mouse_input()

func initial_launch():
    line.visible = false
    arrow_sprite.visible = false
    is_launched = true
    is_input_disabled = true
    launch_ball()
    
    if infinite_ball_spawn or spawned_balls < max_balls_number:
        ball_spawn_timer.start()

    

func launch_ball():
    if not current_ball:
        print("called launch_ball without current_ball")
        return
    
    current_ball.visible = true
    current_ball.mode = 0
    current_ball.go_to_actibe_mode()
    var initial_impulse = get_impulse()
    current_ball.apply_central_impulse(initial_impulse)
#	get_tree().call_group("BallManager", "take_control_of_ball", current_ball)
    current_ball = null
    update_label()

func can_launch():
    return is_input_provided and not is_controlled;

func load_saved_state():
    if initial_state:
        load_state(initial_state)
    else:
        print("called load_saved_state without saved initial_state")

func save_initial_state():
    initial_state = {
        "spawned_balls": spawned_balls,
        "launched_balls":launched_balls,
        "is_input_disabled":is_input_disabled,
        "is_input_provided":is_input_provided, 
        "is_controlled":false, 
        "is_just_received_control_command":false, 
        "end_position":line.points[1],
        "visible": visible,
        "has_ball": true
    }
    
func load_state(state):
    ball_spawn_timer.stop()
    ball_launch_timer.stop()
    spawned_balls = state["spawned_balls"]
    launched_balls = state["launched_balls"]

    is_input_disabled = state["is_input_disabled"]
    is_input_provided = state["is_input_provided"]
    is_controlled = state["is_controlled"]
    is_just_received_control_command = state["is_just_received_control_command"]
    visible = state["visible"]
    
    line.points[1] = state["end_position"]
    arrow_sprite.position = state["end_position"]
    arrow_sprite.rotation = state["end_position"].angle() + 0.5 * PI
    
    if current_ball:
        current_ball.queue_free()
        current_ball = null
    
    if state["has_ball"]:
        spawn_ball()
        
    update_label()

func set_default_initial_impulse():
    var angle = 0.5 * (max_angle + min_angle) * PI / 180
    var end_position = Vector2(min_length, 0).rotated(angle)
    set_end_position(end_position)

func get_impulse():
    if not is_input_provided:
        print("Getting impulse without input")
    
    var impulse =  line.points[1]
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

    line.points[1] = end_position
    arrow_sprite.position = end_position
    arrow_sprite.rotation = end_position.angle() + 0.5 * PI
    sprite.rotation = end_position.angle()
    ball_spawn.position = default_ball_spawn_pos.rotated(end_position.angle())
    ball_spawn.rotation = end_position.angle()
    
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
    
func spawn_ball():
    if current_ball:
        print("attempt to spawn ball with ball already present in ball spawner")
        return
    
    if not infinite_ball_spawn and spawned_balls >= max_balls_number:
        print("attempt to spawn ball with max number of balls already spawned")

    current_ball = ball_prefab.instance()
    current_ball.sleeping = true
    current_ball.mode = 1
    ball_spawn.add_child(current_ball)
    current_ball.rotate(PI)
    spawned_balls += 1

func _on_InteractionArea_mouse_entered():
    is_hovered = true

func _on_InteractionArea_mouse_exited():
    is_hovered = false

func _on_InteractionArea_input_event(viewport, event, shape_idx):
    
    if not is_input_disabled \
    and not is_controlled \
    and event is InputEventMouseButton \
    and event.button_index == BUTTON_LEFT \
    and event.pressed:
        is_controlled = true
        is_just_received_control_command = true


func _on_BallSpawnTimer_timeout():
    spawn_ball()
    ball_launch_timer.start()


func _on_BallLaunchTimer_timeout():
    launch_ball()
    if infinite_ball_spawn or spawned_balls < max_balls_number:
        ball_spawn_timer.start()

func update_label():
    if infinite_ball_spawn:
        label.text = "-"
    else:
        label.text = str(max_balls_number - launched_balls)
