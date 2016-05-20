-- Lengths
function VVPhysics.InchesToMetres (inches)
	return inches * 0.0254
end

function VVPhysics.UnitsToMetres (units)
	return units * 0.75 * 0.0254
end

function VVPhysics.MetresToInches (metres)
	return metres / 0.0254
end

function VVPhysics.MetresToUnits (metres)
	return metres / (0.75 * 0.0254)
end