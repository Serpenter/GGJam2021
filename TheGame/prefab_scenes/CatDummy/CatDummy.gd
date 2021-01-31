extends RigidBody2D

var is_hovered = false
var is_active_mode = false

var is_captured = false
var is_dead = false

#onready var face_normal_sprite = $FaceNormalSprite
#onready var face_sad_sprite = $FaceSadSprite


onready var sprite_body = $SpriteBody
onready var sprite_ears_in = $SpriteEarsIn
onready var sprite_nose = $SpriteNose
onready var sprite_mouth_closed = $SpriteMouthClosed
onready var sprite_mouth_open = $SpriteMouthOpen
onready var sprite_tongue = $SpriteTongue

onready var sprite_legacy_face_normal = $SpriteLegacyFaceNormal
onready var sprite_legacy_face_closed = $SpriteLegacyFaceClosed
onready var sprite_legacy_face_surprised = $SpriteLegacyFaceSurprised

onready var face_timer = $FaceTimer

onready var long_meow = $long_meow

var rng = RandomNumberGenerator.new()

onready var meow_dict = {
    1: $meow_1,
     2: $meow_3,
     3: $meow_3,
     4: $meow_4,
   }

var capture_zones_sum = 0

var use_legacy_faces = true

var is_in_box = false

# Called when the node enters the scene tree for the first time.
func _ready():
    disable_all_forcefield_passes()
    set_appropriate_face()
    get_tree().call_group("CatSubscriber", "_on_cat_changed")


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
    if activation_zone.is_in_group("CaptureZone"):
        go_to_sleep_mode()
        pass

func set_appropriate_face():
    if face_timer.time_left > 0:
        set_closed_face()
    elif is_captured:
        set_surprised_face()
    else:
        set_normal_face()

func _on_InteractionArea_mouse_entered():
    is_hovered = true

func _on_InteractionArea_mouse_exited():
    is_hovered = false

func on_cat_food_entered(cat_food):
    cat_food.on_cat_striked(get_parent().get_parent())


func _on_Cat_body_entered(body):
    if sleeping:
        return
    hide_all_faces()
    face_timer.start()
    play_random_meow()
    set_appropriate_face()
    
    if body.is_in_group("CatFood"):
        on_cat_food_entered(body)

func set_face_color(color):
    sprite_ears_in.modulate = color 
    sprite_nose.modulate = color 

func hide_all_faces():
    sprite_mouth_closed.visible = false
    sprite_mouth_open.visible = false
    sprite_tongue.visible = false
    sprite_legacy_face_normal.visible = false
    sprite_legacy_face_closed.visible = false
    sprite_legacy_face_surprised.visible = false
    
func set_normal_face():
    hide_all_faces()
    
    if use_legacy_faces:
        sprite_legacy_face_normal.visible = true
    else:
        sprite_mouth_closed.visible = true
    
func set_surprised_face():
    hide_all_faces()
    
    if use_legacy_faces:
        sprite_legacy_face_surprised.visible = true
    else:
        sprite_mouth_open.visible = true
        sprite_tongue.visible = true
    

func set_closed_face():
    hide_all_faces()
    
    if use_legacy_faces:
        sprite_legacy_face_closed.visible = true
    else:
        sprite_mouth_open.visible = false
        sprite_tongue.visible = false
    

func _on_FaceTimer_timeout():
    set_appropriate_face()
    
func on_cat_capture_zone_entered(capture_zone):
    capture_zones_sum += 1
    
    if capture_zones_sum > 0:
        is_captured = true
    else:
        print("Negative initial capture_zones_sum value!")
        
    get_tree().call_group("CatSubscriber", "_on_cat_changed")
    set_appropriate_face()
    
func on_cat_capture_box_entered(cat_box):
    is_in_box = true
    sleeping = true
    is_captured = true
    disable_all_colision_layers_and_masks()
    mode = MODE_STATIC
    set_global_position(cat_box.position)
    get_tree().call_group("CatSubscriber", "_on_cat_changed")
    set_appropriate_face()
    if MusicController.is_sound_on:
        long_meow.play()
    
func on_cat_capture_zone_exited(capture_zone):
    capture_zones_sum -= 1
    
    if capture_zones_sum <= 0:
        is_captured = false
    
    if capture_zones_sum < 0:
        print("Negative  capture_zones_sum value!")
        
    get_tree().call_group("CatSubscriber", "_on_cat_changed")
    
    set_appropriate_face()
    
    
    
func disable_all_forcefield_passes():
    var layers_list = Forcefields.get_all_forcefield_layers()
    
    for layer in layers_list:
        set_collision_mask_bit(layer, true)   
    
func disable_all_colision_layers_and_masks():
    for i in range(0,20):
        set_collision_mask_bit(i, false) 
        set_collision_layer_bit(i, false) 
    

func play_random_meow():
    if not MusicController.is_sound_on:
        return
    rng.randomize()
    var meow_number = rng.randi_range(1,4)
    meow_dict[meow_number].play()
