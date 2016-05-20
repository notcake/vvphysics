if SERVER or
   file.Exists ("vvphysics/vvphysics.lua", "LUA") or
   file.Exists ("vvphysics/vvphysics.lua", "LCL") and GetConVar ("sv_allowcslua"):GetBool () then
	include ("vvphysics/vvphysics.lua")
end