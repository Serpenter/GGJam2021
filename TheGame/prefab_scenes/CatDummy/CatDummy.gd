extends RigidBody2D

var is_hovered = false
var is_active_mode = false

var is_captured = false
var is_dead = false

onready var face_normal_sprite = $FaceNormalSprite
onready var face_sad_sprite = $FaceSadSprite
onready var face_timer = $FaceTimer

# Called when the node enters the scene tree for the first time.
func _ready():
    hide_all_faces()
    face_normal_sprite.visible = true


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


func _on_InteractionArea_mouse_entered():
    is_hovered = true

func _on_InteractionArea_mouse_exited():
    is_hovered = false

func on_cat_food_entered(cat_food):
    var cat_position = cat_food.get_global_position()
    cat_food.queue_free()
    get_parent().get_parent().spawn_additional_cat(cat_position)

func _on_Cat_body_entered(body):
    hide_all_faces()
    face_sad_sprite.visible = true
    face_timer.start()
    
    if body.is_in_group("CatFood"):
        on_cat_food_entered(body)

func set_face_color(color):
    face_normal_sprite.modulate = color
    face_sad_sprite.modulate = color

func hide_all_faces():
    face_normal_sprite.visible = false
    face_sad_sprite.visible = false

func _on_FaceTimer_timeout():
    hide_all_faces()
    face_normal_sprite.visible = true
