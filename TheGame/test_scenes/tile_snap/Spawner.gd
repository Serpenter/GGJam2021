extends Position2D


class ObstacleInGameHadle:
    var object_itself
    var picker


export(Color) var modulate_selector 
export(String) var path_to_pickers

const FOLLOW_SPEED = 8.0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_prefab = null
var current_picker = null

var obstacles_container = null
var obstacles_dict = {}

var tile_map = null
var tile_highlight = null

var target_position
var target_tile_id
var target_tile_map_pos


# Called when the node enters the scene tree for the first time.
func _ready():

    for item in get_parent().get_node(path_to_pickers).get_children():
        item.connect("selected", self, "_on_item_selected")
    tile_map = get_parent().get_node("TileMap")
    tile_highlight = tile_map.get_node("Highlight")
    clear_selection()
    obstacles_container = get_parent().get_node("Obstacles")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

    target_tile_map_pos = tile_map.world_to_map(get_global_mouse_position())
    target_tile_id = tile_map.get_cell(target_tile_map_pos.x, target_tile_map_pos.y)
    target_position = tile_map.map_to_world(target_tile_map_pos) + tile_map.cell_size/2
    $Sprite.position = $Sprite.position.linear_interpolate(target_position - position, delta * FOLLOW_SPEED)

    position = get_global_mouse_position()


func _on_item_selected(item_pfb, picker):

    $Sprite.texture = picker.texture
    $Sprite.self_modulate = picker.self_modulate
    $Sprite.modulate = modulate_selector
    $Sprite.show()

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

    if (event is InputEventMouseButton) and event.pressed:
        if current_prefab:
            _handle_event_with_item(event)
        else:
            _handle_event_without_item(event)


func clear_selection():
    current_picker = null
    current_prefab = null
    $Sprite.hide()
    tile_highlight.tiles.clear()
    tile_highlight.update()


func _handle_event_with_item(event):

    if event.button_index == 1:

        if not target_tile_id in current_picker.compatible_tile_ids\
            or target_tile_map_pos in obstacles_dict:
            return

        var new_obstacle = current_prefab.instance()
        new_obstacle.position = target_position
        obstacles_container.add_child(new_obstacle)

        var obj_handle = ObstacleInGameHadle.new()
        obj_handle.object_itself = new_obstacle
        obj_handle.picker = current_picker

        obstacles_dict[target_tile_map_pos] = obj_handle

        current_picker.on_item_placed()

        if not current_picker.is_items_available():
            clear_selection()

    elif event.button_index == 2:
        clear_selection()


func _handle_event_without_item(event):

    if target_tile_map_pos in obstacles_dict and event.button_index in [1, 2]:

        var obj_handle = obstacles_dict.get(target_tile_map_pos)
        obstacles_dict.erase(target_tile_map_pos)

        var node_to_erase = obj_handle.object_itself

        obstacles_container.remove_child(node_to_erase)

        obj_handle.picker.on_item_removed()

        if event.button_index == 1:

            current_picker = obj_handle.picker
            current_prefab = obj_handle.picker.item
            _on_item_selected(current_prefab, current_picker)
