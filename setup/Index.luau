local Core = require("./Core")

local export = {}

export.const = Core

local bin = zune.require.navigate("./")

local path = zune.fs.realPath(bin.."/bin/")

print(zune.fs.path.basename(path.."/libraylib-tmx.so"))

export.lib = zune.ffi.dlopen(path.."/libraylib-tmx.so", Core.def) :: {
    GetSymbol: (self: FFILibrary, symbol: string) -> FFIPointer?,
} & Core.fns

print("worked")

return export