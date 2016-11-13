ernest_swap = class({})

LinkLuaModifier("modifier_ernest_swap", "heroes/invoker/modifiers/modifier_ernest_swap.lua", LUA_MODIFIER_MOTION_NONE )

function ernest_swap:GetIntrinsicModifierName()
	return "modifier_ernest_swap"
end

-- int 2 -> agi 1 -> str 0

function ernest_swap:OnSpellStart()
	caster = self:GetCaster()
	stat = caster:GetPrimaryAttribute()
	print(stat)
	if stat == 2 then
		caster:SetPrimaryAttribute(1)
		caster:SwapAbilities("ernest_int1","ernest_agi1",false,true)
		caster:SwapAbilities("ernest_int2","ernest_agi2",false,true)
		caster:SwapAbilities("ernest_int3","ernest_agi3",false,true)
	end
	if stat == 1 then
		caster:SetPrimaryAttribute(0)
		caster:SwapAbilities("ernest_agi1","ernest_str1",false,true)
		caster:SwapAbilities("ernest_agi2","ernest_str2",false,true)
		caster:SwapAbilities("ernest_agi3","ernest_str3",false,true)
	end
	if stat == 0 then
		caster:SetPrimaryAttribute(2)
		caster:SwapAbilities("ernest_str1","ernest_int1",false,true)
		caster:SwapAbilities("ernest_str2","ernest_int2",false,true)
		caster:SwapAbilities("ernest_str3","ernest_int3",false,true)
	end
end