extends TextureRect


export(int) var how_many
export(PackedScene) var item
export(Array, int) var compatible_tile_ids

export(Color, RGBA) var shade_color

export(bool) var resize_texture = false

var item_ui_rotation_step = 90.0


signal selected(_packed_scene, _texture, _mod_color)


func _ready():

    var tmp_instance = item.instance().get_item_ui_data()

    if resize_texture:
        texture = GUtils.get_resized_texture(tmp_instance.item_ui_texture, tmp_instance.item_ui_size.x, tmp_instance.item_ui_size.y)
    else:
        texture = tmp_instance.item_ui_texture

    self_modulate = tmp_instance.item_ui_color

    $Label.text = str(how_many)
    item_ui_rotation_step = tmp_instance.item_ui_rotation_step

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass:

func _gui_input(event):
    if (event is InputEventMouseButton):
        if event.button_index == 1 \
        and event.pressed \
        and is_items_available() \
        and User.current_control == 0:
            emit_signal("selected", item, self)


func on_item_placed():
    how_many -= 1
    $Label.text = str(how_many)
    if not is_items_available():
        modulate = shade_color


func on_item_removed():
    how_many += 1
    $Label.text = str(how_many)
    if is_items_available():
        modulate = Color.white


func is_items_available():
    return how_many > 0
