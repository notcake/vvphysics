local self = {}
VVPhysics.PhysicsObject = VVPhysics.MakeConstructor (self)

function self:ctor ()
	-- Physical Properties
	self.Mass = 10
	
	-- Source Physics
	self.EngineEntity = nil
	self.EnginePhysicsObject = nil
	
	-- Forces
	self.DragEnabled = true
	self.GravityEnabled = true
	
	-- Kinematics
	self.Position = Vector (0, 0, 0)
	self.Velocity = Vector (0, 0, 0)
	
	-- Forces
	self.ForceAccumulator = Vector (0, 0, 0)
end

function self:dtor ()
end

-- Physics Object
function self:IsShadowPhysicsObject ()
	return false
end

function self:IsValid ()
	return true
end

-- Physical Properties
function self:GetMass ()
	return self.Mass
end

function self:SetMass (mass)
	self.Mass = mass
end

-- Forces
function self:IsDragEnabled ()
	return self.DragEnabled
end

function self:IsGravityEnabled ()
	return self.GravityEnabled
end

function self:SetDragEnabled (dragEnabled)
	self.DragEnabled = dragEnabled
end

function self:SetGravityEnabled (gravityEnabled)
	self.GravityEnabled = gravityEnabled
end

-- Kinematics
function self:GetPosition ()
	return self.Position
end

function self:GetVelocity ()
	return self.Velocity
end

function self:SetPosition (position)
	self.Position = position
end

function self:SetVelocity (velocity)
	self.Velocity = velocity
end

-- Forces
function self:ApplyForce (force)
	self.ForceAccumulator = self.ForceAccumulator + force
end

function self:ClearForces ()
	self.ForceAccumulator = Vector (0, 0, 0)
end

function self:GetAccumulatedForce ()
	return self.ForceAccumulator
end