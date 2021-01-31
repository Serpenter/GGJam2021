extends RigidBody2D

var is_hovered = false
var is_active_mode = false

onready var face_normal_sprite = $FaceNormalSprite
onready var face_sad_sprite = $FaceSadSprite
onready var face_timer = $FaceTimer

onready var hit_sound = $HitSound

export var default_forcefield_pass = "green"

# Called when the node enters the scene tree for the first time.
func _ready():
    hide_all_faces()
    face_normal_sprite.visible = true
    set_forcefield_pass(default_forcefield_pass)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    process_input()

func process_input():
    pass

func go_to_sleep_mode():
    sleeping = true

func go_to_actibe_mode():
    sleeping = false

func on_activation_zone_activated(activation_zone):
    if activation_zone.is_in_group("VictoryZone"):
#		go_to_sleep_mode()
        pass
        
func disable_all_forcefield_passes():
    var layers_list = Forcefields.get_all_forcefield_layers()
    
    for layer in layers_list:
        set_collision_mask_bit(layer, true)
    
    
func set_forcefield_pass(forcefield_name):

    if not Forcefields.is_forcefield_exists(forcefield_name):
        print("attempt to set nonexistant forcefield " + forcefield_name)
        return
        
    disable_all_forcefield_passes()

    var layer = Forcefields.get_forcefield_layer(forcefield_name)
    var color = Forcefields.get_forcefield_color(forcefield_name)
    
    set_collision_mask_bit(layer, false)
    set_face_color(color)
        

        
func on_forcefield_panel_activation(forcefield_panel):
    set_forcefield_pass(forcefield_panel.forcefield_name)

func _on_InteractionArea_mouse_entered():
    is_hovered = true

func _on_InteractionArea_mouse_exited():
    is_hovered = false

func _on_Ball_body_entered(body):
    hide_all_faces()
    face_sad_sprite.visible = true
    face_timer.start()
    hit_sound.play()

func set_face_color(color):
    face_normal_sprite.modulate = color
    face_sad_sprite.modulate = color

func hide_all_faces():
    face_normal_sprite.visible = false
    face_sad_sprite.visible = false

func _on_FaceTimer_timeout():
    hide_all_faces()
    face_normal_sprite.visible = true
