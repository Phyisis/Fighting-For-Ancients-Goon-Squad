wallet_drain = class({})

LinkLuaModifier("modifier_wallet_drain", "heroes/dylan/modifiers/modifier_wallet_drain.lua", LUA_MODIFIER_MOTION_NONE)

function wallet_drain:OnSpellStart()

	local caster = self:GetCaster()

	time = self:GetSpecialValueFor("duration")

	caster:AddNewModifier(caster, self, "modifier_wallet_drain", { duration = time })
	
end

function wallet_drain:OnChannelInterrupted()

	local caster = self:GetCaster()
	caster:RemoveModifierByName("modifier_wallet_drain")

end

function wallet_drain:OnChannelFinish()

	local caster = self:GetCaster()
	caster:RemoveModifierByName("modifier_wallet_drain")

end

function wallet_drain:CastFilterResultTarget(hTarget)

	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end

	filter = UnitFilter(hTarget, 
		DOTA_UNIT_TARGET_TEAM_BOTH, 
		DOTA_UNIT_TARGET_HERO, 
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES,
		self:GetCaster():GetTeamNumber())

	if filter == UF_SUCCESS then
		return filter
	end

	return UF_FAIL_CUSTOM

end

function wallet_drain:GetCustomCastErrorTarget(hTarget)
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end

	if not hTarget:IsHero() then
		return "Ability Only Targets Heroes"
	end

	return ""
end