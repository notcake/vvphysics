local self = {}
VVPhysics.SpacebuildPlanetLoader = VVPhysics.MakeConstructor (self)

function self:ctor ()
end

function self:LoadMap (spacebuildEnvironment)
	spacebuildEnvironment = spacebuildEnvironment or VVPhysics.SpacebuildEnvironment ()
	
	for _, logic_case in ipairs (ents.FindByClass ("logic_case")) do
		local spacebuildPlanet = self:LoadPlanet (logic_case)
		if spacebuildPlanet then
			spacebuildEnvironment:AddPlanet (spacebuildPlanet)
		end
	end
	
	return spacebuildEnvironment
end

function self:LoadPlanet (logic_case, spacebuildPlanet)
	local keyValues = logic_case:GetKeyValues ()
	local class = keyValues.Case01
	if class == "planet" then
		spacebuildPlanet = spacebuildPlanet or VVPhysics.SpacebuildPlanet ()
		spacebuildPlanet:SetEntity (logic_case)
		
		local radius = VVPhysics.UnitsToMetres (tonumber (keyValues.Case02))
		spacebuildPlanet:SetRadius (radius)
		
		local g = VVPhysics.UnitsToMetres (tonumber (keyValues.Case03) * 600)
		
		local mass = g * radius * radius / VVPhysics.Constants.G
		spacebuildPlanet:SetMass (mass)
	end
	
	return spacebuildPlanet
end

VVPhysics.SpacebuildPlanetLoader = VVPhysics.SpacebuildPlanetLoader ()