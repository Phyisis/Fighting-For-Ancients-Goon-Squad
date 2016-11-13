ernest_swap = class({})

LinkLuaModifier("modifier_ernest_swap", "heroes/invoker/modifiers/modifier_ernest_swap.lua", LUA_MODIFIER_MOTION_NONE )

function ernest_swap:GetIntrinsicModifierName()
	return "modifier_ernest_swap"
end

function ernest_swap:OnSpellStart()

	caster = self:GetCaster()
	stat = caster:GetPrimaryAttribute()
	
	if stat == DOTA_ATTRIBUTE_INTELLECT then
		caster:SetPrimaryAttribute(DOTA_ATTRIBUTE_AGILITY)
		caster:SwapAbilities("ernest_int1","ernest_agi1",false,true)
		caster:SwapAbilities("ernest_int2","ernest_agi2",false,true)
		caster:SwapAbilities("ernest_int3","ernest_agi3",false,true)
	end

	if stat == DOTA_ATTRIBUTE_AGILITY then
		caster:SetPrimaryAttribute(DOTA_ATTRIBUTE_STRENGTH)
		caster:SwapAbilities("ernest_agi1","ernest_str1",false,true)
		caster:SwapAbilities("ernest_agi2","ernest_str2",false,true)
		caster:SwapAbilities("ernest_agi3","ernest_str3",false,true)
	end

	if stat == DOTA_ATTRIBUTE_STRENGTH then
		caster:SetPrimaryAttribute(DOTA_ATTRIBUTE_INTELLECT)
		caster:SwapAbilities("ernest_str1","ernest_int1",false,true)
		caster:SwapAbilities("ernest_str2","ernest_int2",false,true)
		caster:SwapAbilities("ernest_str3","ernest_int3",false,true)
	end

	caster:CalculateStatBonus()

end