local self = {}
VVPhysics.SpacebuildEnvironment = VVPhysics.MakeConstructor (self)

function self:ctor (physicsEnvironment)
	self.Planets = {} -- Actually includes moons as well
	
	self.PhysicsEnvironment = physicsEnvironment
	self.GravityController = VVPhysics.SpacebuildGravityController (self)
	self.PhysicsEnvironment:AddForceController (self.GravityController)
	
	VVPhysics.SpacebuildPlanetLoader:LoadMap (self)
	
	hook.Add ("InitPostEntity", "VVPhysics.Spacebuild",
		function ()
			VVPhysics.SpacebuildPlanetLoader:LoadMap (self)
		end
	)
	
	for _, ent in ipairs (ents.GetAll ()) do
		self:AddEntity (ent)
	end
	
	hook.Add ("OnEntityCreated", "VVPhysics.Spacebuild",
		function (ent)
			self:AddEntity (ent)
		end
	)
end

function self:dtor ()
	hook.Remove ("InitPostEntity",     "VVPhysics.Spacebuild")
	hook.Remove ("OnEntityCreated",    "VVPhysics.Spacebuild")
end

-- Planets
function self:AddPlanet (planet)
	if not planet then return end
	
	self.Planets [#self.Planets + 1] = planet
end

function self:GetPlanet (planetId)
	return self.Planets [planetId]
end

function self:GetPlanetCount ()
	return #self.Planets
end

function self:GetPlanetEnumerator ()
	local i = 0
	return function ()
		i = i + 1
		return self.Planets [i]
	end
end

function self:RemovePlanet (planet)
	if not planet then return end
	
	for i = 1, #self.Planets do
		if self.Planets [i] == planet then
			table.remove (self.Planets, i)
			return
		end
	end
end

-- Force Controllers
function self:GetGravityController ()
	return self.GravityController
end

-- Internal, do not call
function self:AddEntity (ent)
	GLib.CallDelayed (
		function ()
			if not self:ShouldAddEntity (ent) then return end
			
			ent.VVPhysicsObject = ent.VVPhysicsObject or VVPhysics.ShadowPhysicsObject (ent, ent:GetPhysicsObject ())
			self.PhysicsEnvironment:AddObject (ent.VVPhysicsObject)
		end
	)
end

function self:ShouldAddEntity (ent)
	if not ent then return false end
	if not ent:IsValid () then return false end
	if ent:EntIndex () < 0 then return false end
	if not ent:GetPhysicsObject () then return false end
	if not ent:GetPhysicsObject ():IsValid () then return false end
	if not ent:GetPhysicsObject ():IsMoveable () then return false end
	
	return true
end