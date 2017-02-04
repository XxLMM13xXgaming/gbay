if (SERVER) then
  include("gbay/core/sv_core.lua")
  AddCSLuaFile("gbay/core/cl_core.lua")
end
if (CLIENT) then
  include("gbay/core/cl_core.lua")
end
