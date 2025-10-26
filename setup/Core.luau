local FFI = zune.ffi

local int = FFI.types.i32
local uint = FFI.types.u32
local bool = FFI.types.u8
local float = FFI.types.float
local pointer = FFI.types.pointer
local long = FFI.types.i64
local void = FFI.types.void
local double = FFI.types.double
local cstring = FFI.types.pointer

type int = number;
type uint = number;
type bool = number;
type float = number;
type long = buffer;
type double = number;

type Pointer = FFIPointer

local tmx_properties = void


export type tmx_properties = typeof(tmx_properties)

---------------------------------------------------------
local tmx_tileset_list = FFI.struct({})
export type tmx_tileset_list = typeof(tmx_tileset_list)

local Color = FFI.struct({
    { r = FFI.types.u8 },
    { g = FFI.types.u8 },
    { b = FFI.types.u8 },
    { a = FFI.types.u8 },
});
export type Color = typeof(Color:new({}))


local tmx_user_data = FFI.struct(
    {
        {integer = int},
        {decimal = float},
        {pointer = void}
    }
)
export type tmx_user_data = typeof(tmx_user_data)

local tmx_property_value = FFI.struct(
    {
        {integer = int},
        {boolean = bool},
        {decimal = float},
        {color = Color}
    }
)
export type tmx_property_value = typeof(tmx_property_value)

local tmx_image = FFI.struct(
    {
        {source = FFI.types.pointer},
        {trans = uint},
        {use_trans = int},
        {width = long},
        {height = long},
        {resource_magine = void}
    }
)
export type tmx_image = typeof(tmx_image:new({}))

local tmx_tileset = FFI.struct({})
export type tmx_tileset = typeof(tmx_tileset)
local tmx_object,tmx_template



tmx_template = FFI.struct(
    {
        {is_embedded = int},
        {tileset_ref = tmx_tileset_list},
        {object = FFI.types.pointer}
    }
)

local tmx_shape = FFI.struct(
    {
        {points = double},
        {points_len = int}
    }
)

local tmx_anim_frame = FFI.struct(
    {
        {tile_id = uint},
        {duration = uint}
    }
)

local tmx_text = FFI.struct(
    {
        {fontfamily = FFI.types.pointer},
        {pixelsize = int},
        {color = Color},
        {wrap = int},
        {bold = int},
        {italic = int},
        {underline = int},
        {strikeout = int},
        {kerning = int},
        {tmx_horizontal_align = int},
        {tmx_vertical_align = int},
        {text = FFI.types.pointer}
    }
)

export type tmx_text = typeof(tmx_text)


local content = FFI.struct(
    {
        {gid = int},
        {shape = tmx_shape},
        {text = tmx_text}
    }
)

local tmx_prop = FFI.struct(
    {
        {name = FFI.types.pointer},
        {tmx_property_type = int},
        {value = tmx_property_value}
    }
)

export type tmx_prop = typeof(tmx_prop)

tmx_object = FFI.struct(
    {
        {id = uint},
        {obj_type = int},
        {x = double},
        {y = double},
        {width = double},
        {height = double},
        {content = content},
        {visible = int},
        {rotation = double},
        {char = FFI.types.pointer},
        {type = FFI.types.pointer},
        {template_ref = tmx_template},
        {properties = tmx_properties},
        {next = FFI.types.pointer}
    }
)

local tmx_object_group = FFI.struct(
    {
        {color = uint},
        {draworder = int},
        {head = tmx_object}
    }
)
--FFI.struct({{gids = uint}, {objgr = tmx_object_group}, {image = tmx_image}, {group_head = tmx_layer}})}

local tmx_layer = FFI.struct(
    {
        {id = int},
        {name = FFI.types.pointer},
        {opacity = double},
        {visible = bool},
        {offsetx = int},
        {offsety = int},
        {parallaxx = double},
        {parallaxy = double},
        {tintcolor = uint},
        {tmx_layer_type = int},
        {content = FFI.types.pointer},
        {user_data = tmx_user_data},
        {properties = tmx_properties},
        {next = FFI.types.pointer}
    }
)
export type tmx_layer = typeof(tmx_layer)

local tmx_tile = FFI.struct(
    {
        {id = int},
        {tileset = tmx_tileset},
        {ul_x = uint},
        {ul_y = uint},
        {image = tmx_image},
        {collision = tmx_object},
        {type = FFI.types.pointer},
        {animation_len = uint},
        {animation = tmx_anim_frame},
        {user_data = tmx_user_data}
    }
)
export type tmx_tile = typeof(tmx_tile)

local tmx_map = FFI.struct(
    {
        {tmx_map_orient = int},
        {width = uint},
        {height = uint},
        {tile_width = uint},
        {tile_height = uint},
        {tmx_stagger_index = int},
        {tmx_stagger_axis = int},
        {hexsidelength = int},
        {backgroundcolor = uint},
        {tmx_map_renderorder = int},
        {properties = tmx_properties},
        {ts_head = tmx_tileset_list},
        {ly_head = tmx_layer},
        {tilecount = uint},
        {tiles = tmx_tile},
        {user_data = tmx_user_data}
    }
)
export type tmx_map = typeof(tmx_map:new({}))

export type fns = {
    LoadTMX: (fileName: FFIPointerType) -> (),
    UnloadTMX: (map: tmx_map) -> (),
    ColorFromTMX: (color: Color) -> (),
    DrawTMX: (map: tmx_map, posX: number, posY: number, tint: Color) -> (),
    DrawTMXLayers: (map: tmx_map, layers: tmx_layer, posX: number, posY: number, tint: Color) -> (),
    DrawTMXLayer: (map: tmx_map, layer: tmx_layer, posX: number, posY: number, tint: Color) -> (),
    DrawTMXTile: (tile: tmx_tile, posX: number, posY: number, tint: Color) -> ()
}


local function fn(returns: any, args: { any })
    return {
        returns = returns,
        args = args,
    }
end


return {
     def = { 
        LoadTMX = fn(void, {cstring}),
        UnloadTMX = fn(void, {tmx_map}),
        ColorFromTMX = fn(void, {Color}),
        DrawTMX = fn(void, {tmx_map, int, int, Color}),
        DrawTMXLayers = fn(void, {tmx_map, tmx_layer, int, int, Color}),
        DrawTMXLayer = fn(void, {tmx_map, tmx_layer, int, int, Color}),
        DrawTMXTile = fn(void, {tmx_tile, int, int, Color})
    }
}
