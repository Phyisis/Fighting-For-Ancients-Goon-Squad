chilling_blade = class({})

LinkLuaModifier("modifier_chilling_blade", "heroes/drackos/modifiers/modifier_chilling_blade.lua", LUA_MODIFIER_MOTION_NONE)

function chilling_blade:OnOrbFire( event )
	print("orb fired")
	--self:StartCooldown(self:GetCooldown(self:GetLevel()))
	--self:PayManaCost()
	local hCaster = event.caster
	local hTarget = event.target
	print(hTarget)
	damage = self:GetSpecialValueFor("damage")
	duration = self:GetSpecialValueFor("duration")

	--hCaster:PerformAttack(hTarget, true, true, false, false, false)
	
	hTarget:AddNewModifier(hCaster, self, "modifier_chilling_blade", {["duration"] = duration})
	
	local damageTable = {
		victim = hTarget,
		attacker = hCaster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
	}
	ApplyDamage(damageTable) 
end