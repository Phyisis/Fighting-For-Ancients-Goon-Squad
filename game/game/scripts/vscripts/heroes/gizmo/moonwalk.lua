moonwalk = class({})

LinkLuaModifier("modifier_moonwalk", "heroes/gizmo/modifiers/modifier_moonwalk.lua", LUA_MODIFIER_MOTION_NONE)

function moonwalk:OnSpellStart()
	caster = self:GetCaster()
	target = self:GetCursorTarget()
	duration = self:GetSpecialValueFor("duration")
	velocity = self:GetSpecialValueFor("velocity")
	num = 0
	
	target:AddNewModifier(caster, self, "modifier_moonwalk", {["duration"] = duration})
	
	Timers:CreateTimer(0, function()		
		direction = target:GetForwardVector()
		target:SetAbsOrigin(target:GetAbsOrigin() - direction * velocity)
		FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
						
		num = num + .033
		
		if num < duration then
			return .033
		end
	end)
	
end