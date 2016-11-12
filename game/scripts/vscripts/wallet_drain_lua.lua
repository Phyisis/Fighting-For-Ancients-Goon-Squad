wallet_drain_lua = class({})

LinkLuaModifier("modifier_wallet_drain_lua", LUA_MODIFIER_MOTION_NONE)

function wallet_drain_lua:OnSpellStart()

	local caster = self:GetCaster()

	time = self:GetSpecialValueFor("duration")

	caster:AddNewModifier(caster, self, "modifier_wallet_drain_lua", { duration = time })
	
end

function wallet_drain_lua:OnChannelInterrupted()

	local caster = self:GetCaster()
	caster:RemoveModifierByName("modifier_wallet_drain_lua")

end

function wallet_drain_lua:OnChannelFinish()

	local caster = self:GetCaster()
	caster:RemoveModifierByName("modifier_wallet_drain_lua")

end

function wallet_drain_lua:CastFilterResultTarget(hTarget)

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

function wallet_drain_lua:GetCustomCastErrorTarget(hTarget)
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end

	if not hTarget:IsHero() then
		return "Ability Only Targets Heroes"
	end

	return ""
end