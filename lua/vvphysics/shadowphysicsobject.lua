local self = {}
VVPhysics.ShadowPhysicsObject = VVPhysics.MakeConstructor (self, VVPhysics.PhysicsObject)

function self:ctor (engineEntity, enginePhysicsObject)
	self:SetEngineEntity (engineEntity)
	self:SetEnginePhysicsObject (enginePhysicsObject)
end

function self:dtor ()
	self:SetEngineEntity (nil)
end

-- Physics Object
function self:IsShadowPhysicsObject ()
	return true
end

function self:IsValid ()
	if not self.EngineEntity then return false end
	if not self.EngineEntity:IsValid () then return false end
	if not self.EnginePhysicsObject then return false end
	if not self.EnginePhysicsObject:IsValid () then return false end
	return true
end

-- Source Physics
function self:GetEngineEntity ()
	return self.EngineEntity
end

function self:GetEnginePhysicsObject ()
	return self.EnginePhysicsObject
end

function self:SetEngineEntity (engineEntity)
	if self.EngineEntity and self.EngineEntity:IsValid () then
		self.EngineEntity.VVPhysicsObject = nil
	end
	
	self.EngineEntity = engineEntity
	
	if self.EngineEntity then
		self.EngineEntity.VVPhysicsObject = self
	end
end

function self:SetEnginePhysicsObject (enginePhysicsObject)
	self.EnginePhysicsObject = enginePhysicsObject
end

-- Physical Properties
function self:GetMass ()
	if not self:IsValid () then return 0 end
	return self.EnginePhysicsObject:GetMass ()
end

function self:SetMass (mass)
	if not self:IsValid () then return end
	self.EnginePhysicsObject:SetMass (mass)
end

-- Kinematics
function self:GetPosition ()
	if not self:IsValid () then return Vector (0, 0, 0) end
	return self.EnginePhysicsObject:GetPos ()
end

function self:GetVelocity ()
	if not self:IsValid () then return Vector (0, 0, 0) end
	self.EnginePhysicsObject:GetVelocity ()
end

function self:SetPosition (position)
	if not self:IsValid () then return end
	self.EnginePhysicsObject:SetPos (position)
end

function self:SetVelocity (velocity)
	if not self:IsValid () then return end
	self.EnginePhysicsObject:SetVelocity (velocity)
end

-- Engine Force Control
function self:IsEngineDragEnabled ()
	if not self:IsValid () then return false end
	return self.EnginePhysicsObject:IsDragEnabled ()
end

function self:IsEngineGravityEnabled ()
	if not self:IsValid () then return false end
	return self.EnginePhysicsObject:IsGravityEnabled ()
end

function self:SetEngineDragEnabled (engineDragEnabled)
	if not self:IsValid () then return end
	self.EnginePhysicsObject:EnableDrag (engineDragEnabled)
end

function self:SetEngineGravityEnabled (engineGravityEnabled)
	if not self:IsValid () then return end
	
	self.EnginePhysicsObject:EnableGravity (engineGravityEnabled)
	
	if self.EngineEntity:IsPlayer () then
		self.EngineEntity:SetGravity (engineGravityEnabled and 1 or 1e-40)
	end
end