local self = {}
self.ForceType = VVPhysics.ForceType.Gravity
VVPhysics.DefaultGravityController = VVPhysics.MakeConstructor (self, VVPhysics.IForceController)

function self:ctor ()
end

if SERVER then
	function self:ApplyForce (physicsObject, dt)
		physicsObject:ApplyForce (VVPhysics.UnitsToMetres (physenv.GetGravity ()))
	end
elseif CLIENT then
	function self:ApplyForce (physicsObject, dt)
		physicsObject:ApplyForce (Vector (0, 0, -VVPhysics.UnitsToMetres (600)))
	end
end