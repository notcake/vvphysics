local self = {}
self.ForceType = VVPhysics.ForceType.Gravity
VVPhysics.SpacebuildGravityController = VVPhysics.MakeConstructor (self, VVPhysics.IForceController)

function self:ctor (spacebuildEnvironment)
	self.SpacebuildEnvironment = spacebuildEnvironment
end

function self:ApplyForce (physicsObject, dt)
	physicsObject:ApplyForce (physicsObject:GetMass () * self:GetGravitationalAcceleration (physicsObject))
end

function self:GetGravitationalAcceleration (physicsObject)
	if physicsObject.Planet then
		local r = physicsObject.Planet:GetRadius ()
		return Vector (0, 0, -VVPhysics.Constants.G * physicsObject.Planet:GetMass () / (r * r))
	end
	
	local position = physicsObject:GetPosition ()
	
	-- g = GMr / |r|^2
	
	local gx = 0
	local gy = 0
	local gz = 0
	local closestDistance = math.huge
	for planet in self.SpacebuildEnvironment:GetPlanetEnumerator () do
		local r = VVPhysics.UnitsToMetres (position - planet:GetPosition ())
		local r_length = r:Length ()
		
		-- Cache GM / |r| ^ 3
		local k = VVPhysics.Constants.G * planet:GetMass () / (r_length * r_length * r_length)
		
		-- g -= GM r / |r| ^ 3
		if r_length < closestDistance then
			gx = - r.x * k
			gy = - r.y * k
			gz = - r.z * k
			closestDistance = r_length
		end
	end
	return Vector (gx, gy, gz)
end

function self:IsInPlanet (position)
	for planet in self.SpacebuildEnvironment:GetPlanetEnumerator () do
		if planet:ContainsPoint (position) then return true end
	end
	return false, nil
end

function self:Tick (physicsEnvironment, dt)
	for physicsObject in physicsEnvironment:GetEnumerator () do
		local onPlanet = physicsObject.Planet ~= nil
		local planet = physicsObject.Planet
		if onPlanet then
			if VVPhysics.UnitsToMetres ((physicsObject:GetPosition () - planet:GetPosition ()):Length ()) > planet:GetRadius () then
				onPlanet = false
				planet = nil
			end
		else
			onPlanet, planet = self:IsInPlanet (physicsObject:GetPosition ())
		end
		physicsObject:SetEngineDragEnabled (onPlanet)
		physicsObject:SetEngineGravityEnabled (onPlanet)
		physicsObject.Planet = planet
	end
end