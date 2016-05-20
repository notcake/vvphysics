local self = {}
VVPhysics.PhysicsEnvironment = VVPhysics.MakeConstructor (self)

function self:ctor ()
	self.Objects = {}
	
	self.ForceControllers = {}
end

function self:dtor ()
	for object in self:GetEnumerator () do
		object:dtor ()
	end
end

-- Objects
function self:AddObject (object)
	self.Objects [object] = true
end

function self:GetEnumerator ()
	local next, tbl, key = pairs (self.Objects)
	return function ()
		key = next (tbl, key)
		return key
	end
end

function self:RemoveObject (object)
	self.Objects [object] = nil
end

-- Forces
function self:AddForceController (forceController)
	self.ForceControllers [forceController] = true
end

function self:RemoveForceController (forceController)
	self.ForceControllers [forceController] = nil
end

-- Simulation
function self:Advance (dt)
	-- Remove objects whose engine entity has been removed
	for physicsObject, _ in pairs (self.Objects) do
		if physicsObject:IsShadowPhysicsObject () and
		   not physicsObject:IsValid () then
			physicsObject:dtor ()
			self.Objects [physicsObject] = nil
		end
	end
	
	-- Clear all forces
	for physicsObject in self:GetEnumerator () do
		physicsObject:ClearForces ()
	end
	
	-- Apply gravity, drag, etc.
	for forceController in pairs (self.ForceControllers) do
		forceController:Tick (self, dt)
		forceController:ApplyForces (self, dt)
	end
	
	-- Integrate!
	for physicsObject in self:GetEnumerator () do
		if physicsObject:IsShadowPhysicsObject () then
			if physicsObject:GetEngineEntity ():IsPlayer () then
				if physicsObject:GetEngineEntity ():GetMoveType () ~= 8 then
					physicsObject:GetEngineEntity ():SetVelocity (VVPhysics.MetresToUnits (physicsObject:GetAccumulatedForce () / physicsObject:GetMass ()))
				end
			else
				physicsObject:GetEnginePhysicsObject ():ApplyForceCenter (VVPhysics.MetresToUnits (physicsObject:GetAccumulatedForce ()))
			end
		else
			-- RK4 integration?
		end
	end
end