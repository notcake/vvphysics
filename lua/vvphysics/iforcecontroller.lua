local self = {}
self.ForceType = VVPhysics.ForceType.Other
VVPhysics.IForceController = VVPhysics.MakeConstructor (self)

function self:ctor ()
end

function self:ApplyForces (physicsEnvironment, dt)
	for physicsObject in physicsEnvironment:GetEnumerator () do
		if self:ShouldApplyForce (physicsObject, dt) then
			self:ApplyForce (physicsObject, dt)
		end
	end
end

function self:ApplyForce (physicsObject, dt)
end

function self:GetForceType ()
	return self.ForceType
end

function self:ShouldApplyForce (physicsObject, dt)
	if not physicsObject:IsShadowPhysicsObject () then return end
	if self:GetForceType () == VVPhysics.ForceType.Gravity and not physicsObject:IsGravityEnabled () then return false end
	if self:GetForceType () == VVPhysics.ForceType.Gravity and physicsObject:IsEngineGravityEnabled () then return false end
	if self:GetForceType () == VVPhysics.ForceType.Drag and not physicsObject:IsDragEnabled () then return false end
	if self:GetForceType () == VVPhysics.ForceType.Drag and physicsObject:IsEngineDragEnabled () then return false end
	return true
end

function self:Tick (dt)
end