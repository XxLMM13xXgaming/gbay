if (SERVER) then
  if !file.Exists("gbay","DATA") then
    file.CreateDir("gbay")
  end
  include("gbay/core/sv_core.lua")
  include("gbay/core/sh_core.lua")
  AddCSLuaFile("gbay/core/cl_core.lua")
  AddCSLuaFile("gbay/core/sh_core.lua")
end
if (CLIENT) then
  include("gbay/core/cl_core.lua")
  include("gbay/core/sh_core.lua")
end
