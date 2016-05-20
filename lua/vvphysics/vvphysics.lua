if VVPhysics then return end
VVPhysics = VVPhysics or {}

include ("glib/glib.lua")

GLib.Initialize ("VVPhysics", VVPhysics)
GLib.AddCSLuaPackSystem ("VVPhysics")
GLib.AddCSLuaPackFile ("autorun/vvphysics.lua")
GLib.AddCSLuaPackFolderRecursive ("vvphysics")

include ("constants.lua")
include ("unitconversion.lua")

include ("forcetype.lua")
include ("iforcecontroller.lua")
include ("defaultgravitycontroller.lua")

include ("physicsenvironment.lua")
include ("physicsobject.lua")
include ("shadowphysicsobject.lua")

include ("gases/atmosphere.lua")
include ("gases/gasmixture.lua")

include ("spacebuild/spacebuildenvironment.lua")
include ("spacebuild/spacebuildplanet.lua")
include ("spacebuild/spacebuildplanetloader.lua")

include ("spacebuild/spacebuildgravitycontroller.lua")

VVPhysics.Environment = VVPhysics.PhysicsEnvironment ()
if string.lower (string.sub (game.GetMap (), 1, 3)) == "sb_" then
	VVPhysics.SpacebuildEnvironment = VVPhysics.SpacebuildEnvironment (VVPhysics.Environment)
end

VVPhysics:AddEventListener ("Unloaded",
	function ()
		VVPhysics.Environment:dtor ()
		
		for _, ent in ipairs (ents.GetAll ()) do
			ent.VVPhysicsObject = nil
		end
	end
)

local t = CurTime ()
hook.Add ("Think", "VVPhysics.PhysicsEnvironment",
	function ()
		local dt = CurTime () - t
		t = CurTime ()
		
		VVPhysics.Environment:Advance (dt)
	end
)

VVPhysics.AddReloadCommand ("vvphysics/vvphysics.lua", "vvphysics", "VVPhysics")