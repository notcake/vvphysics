local self = {}
VVPhysics.SpacebuildPlanet = VVPhysics.MakeConstructor (self)

function self:ctor (logic_case)
	self.Entity = nil
	
	self.Mass = 0
	self.Radius = 0
	self.Atmosphere = VVPhysics.Atmosphere ()
	
	if logic_case then
		VVPhysics.SpacebuildPlanetLoader:LoadPlanet (logic_case, planet)
	end
end

-- Physical Properties
function self:GetAtmosphere ()
	return self.Atmosphere
end

function self:GetEntity ()
	return self.Entity
end

function self:GetMass ()
	return self.Mass
end

function self:SetEntity (entity)
	self.Entity = entity
end

function self:SetMass (mass)
	self.Mass = mass
end

-- Geometry
function self:ContainsPoint (position)
	local r = VVPhysics.UnitsToMetres ((position - self:GetPosition ()):Length ())
	return r <= self:GetRadius ()
end

function self:GetRadius ()
	return self.Radius
end

function self:SetRadius (radius)
	self.Radius = radius
end

-- Kinematics
function self:GetPosition ()
	return self.Entity:GetPos ()
end

function self:GetVelocity ()
	return self.Entity:GetVelocity ()
end