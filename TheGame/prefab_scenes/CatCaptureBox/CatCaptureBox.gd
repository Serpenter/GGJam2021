extends Node2D

# presistent parameters - to be saved-restored-loaded
var initial_rotation
export(bool) var is_alignable = true

onready var static_body = $StaticBody2D
onready var no_capture_light = $LightNoCapture
onready var capture_light_1 = $LightCapture1
onready var capture_light_2 = $LightCapture2
onready var lid_sprite = $SpriteBoxLid

var initial_state = null

var is_capture_mode = false

# Called when the node enters the scene tree for the first time.
func _ready():
    capture_mode_deactivated()
    
func load_saved_state():
    capture_mode_deactivated()

func save_initial_state():
    pass
    
func load_state(state):
    pass

func get_item_ui_data():
    return $ItemUIData
    
func capture_mode_deactivated():
    static_body.set_collision_layer_bit(1, false)
    no_capture_light.visible = true
    capture_light_1.visible = false
    capture_light_2.visible = false
    lid_sprite.visible = false

func capture_mode_activated():
    static_body.set_collision_layer_bit(1, true)
    no_capture_light.visible = false
    capture_light_1.visible = true
    capture_light_2.visible = true
    lid_sprite.visible = true
    

func _on_InteractionArea_body_entered(body):
    if is_capture_mode:
        return

    if body.has_method("on_cat_capture_box_entered"):
        body.on_cat_capture_box_entered(self) 
        capture_mode_activated()


func _on_InteractionArea_body_exited(body):
    if body.has_method("on_cat_capture_box_exited"):
        body.on_cat_capture_zone_exited(self)
