extends Node

@export_group("Node Settings")
@export var map: TileMapLayer
@export var highlight_color: Color = Color(1.0, 1.0, 1.0, 0.392)
@export var enable: bool = true :
    set(value):
        set_process(value)


var highlight_rectangle: ColorRect
var last_hovered_tile: Vector2i

func _ready() -> void:
    highlight_rectangle = ColorRect.new()
    highlight_rectangle.size = map.tile_set.tile_size
    highlight_rectangle.color = highlight_color
    highlight_rectangle.visible = false
    add_child(highlight_rectangle)
    last_hovered_tile = Vector2i(-1, -1)


func _process(_delta: float) -> void:
    var global_mouse_pos = owner.get_global_mouse_position()
    var map_local_pos = map.to_local(global_mouse_pos)
    var current_tile_coords: Vector2i = map.local_to_map(map_local_pos)
    if current_tile_coords != last_hovered_tile:
        last_hovered_tile = current_tile_coords
        var tile_global_pos = map.to_global(map.map_to_local(current_tile_coords))
        highlight_rectangle.global_position = Vector2(
            tile_global_pos.x - highlight_rectangle.size.x / 2,
            tile_global_pos.y - highlight_rectangle.size.y / 2)
    
        if not highlight_rectangle.visible:
            highlight_rectangle.visible = true

    
