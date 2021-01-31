extends RigidBody2D

var can_grab = false
var grabbed_offset = Vector2()
export var force = Vector2(0.1, 0.1)
var max_impulse_abs = 50

var max_box_scale = 1
var min_box_scale = 0.01
var scale_modifier = 1000

var finished = false
onready var sprite = $Sprite


func _process(delta):
    if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_grab:
        grabbed_offset = get_global_transform().origin - get_global_mouse_position()
    else:
        can_grab = false
        grabbed_offset = Vector2(0, 0)
        

func _physics_process(delta):
    if finished:
        return
    position -= delta * position * 0.15
    rotation += delta * 0.3
    update_box_scale()
    if position.length_squared() < 600:
        on_finish()
        
func on_finish():
    finished = true
    visible = false
    if MusicController.is_sound_on:
        $long_meow.play()
    
    

func _integrate_forces(state):
    return
    grabbed_offset = position * 0.005
    var impulse = -grabbed_offset * force
    if impulse.length() > max_impulse_abs:
        var angle = impulse.angle()
        impulse = max_impulse_abs * Vector2(1,0).rotated(angle)
    state.apply_central_impulse(impulse)

func update_box_scale():
    var new_scale = position.length() / scale_modifier
    new_scale = min(new_scale, max_box_scale)
    new_scale = max(new_scale, min_box_scale)
    sprite.scale = Vector2(new_scale, new_scale)


func _on_InteractableBox_input_event(viewport, event, shape_idx):
    if event is InputEventMouseButton:
        print("can grab")
        can_grab = event.pressed
