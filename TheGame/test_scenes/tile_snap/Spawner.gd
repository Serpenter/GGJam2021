extends Position2D

export(Color) var modulate_selector 
const FOLLOW_SPEED = 8.0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_prefab = null
var current_picker = null

var tile_map = null
var tile_highlight = null
var target_position
var target_tile_id

# Called when the node enters the scene tree for the first time.
func _ready():

    for item in get_parent().get_node("CanvasLayer/Selector/HBoxContainer").get_children():
        item.connect("selected", self, "_on_item_selected")
    $Area2D/CollisionShape2D.disabled = true
    tile_map = get_parent().get_node("TileMap")
    tile_highlight = tile_map.get_node("Highlight")
    clear_selection()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

    if current_prefab:

        position = get_global_mouse_position()

        var tile_map_pos = tile_map.world_to_map(get_global_mouse_position())
        # for future use
        target_tile_id = tile_map.get_cell(tile_map_pos.x, tile_map_pos.y)
        
        target_position = tile_map.map_to_world(tile_map_pos) + tile_map.cell_size/2
        $Sprite.position = $Sprite.position.linear_interpolate(target_position - position, delta * FOLLOW_SPEED)


func _on_item_selected(item_pfb, picker):

    $Sprite.texture = picker.texture
    $Sprite.self_modulate = picker.self_modulate
    $Sprite.modulate = modulate_selector
    $Sprite.show()

    $Area2D/CollisionShape2D.disabled = false
    current_prefab = item_pfb
    current_picker = picker

    tile_highlight.tiles.clear()
    tile_highlight.tile_size = tile_map.cell_size * 0.9
    tile_highlight.tile_offset = tile_map.cell_size * 0.05
    
    for tid in current_picker.compatible_tile_ids:

        var tiles_by_id = tile_map.get_used_cells_by_id(tid)

        for tile in tiles_by_id:
            tile_highlight.tiles.append(tile_map.map_to_world(tile))

    tile_highlight.update()


func _on_Area2D_input_event(viewport, event, shape_idx):

    if current_prefab and (event is InputEventMouseButton) and event.pressed:

        if event.button_index == 1:

            if not target_tile_id in current_picker.compatible_tile_ids:
                return

            var new_obstacle = current_prefab.instance()
            new_obstacle.position = target_position
            get_parent().get_node("Obstacles").add_child(new_obstacle)

            current_picker.on_item_picked()

            if not current_picker.is_items_available():
                clear_selection()

        elif event.button_index == 2:
            clear_selection()


func clear_selection():
    current_picker = null
    current_prefab = null
    $Area2D/CollisionShape2D.disabled = true
    $Sprite.hide()
    tile_highlight.tiles.clear()
    tile_highlight.update()
