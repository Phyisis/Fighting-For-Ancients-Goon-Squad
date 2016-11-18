ernest_swap = class({})

LinkLuaModifier("modifier_ernest_swap_agi", "heroes/invoker/modifiers/modifier_ernest_swap_agi.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_ernest_swap_int", "heroes/invoker/modifiers/modifier_ernest_swap_int.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_ernest_swap_str", "heroes/invoker/modifiers/modifier_ernest_swap_str.lua", LUA_MODIFIER_MOTION_NONE )

function ernest_swap:OnUpgrade()
	caster = self:GetCaster()
	if self:GetLevel() == 1 then
		caster:AddNewModifier(caster, self, "modifier_ernest_swap_int", nil)
	end
end

function ernest_swap:OnSpellStart()

	caster = self:GetCaster()
	stat = caster:GetPrimaryAttribute()
	
	if stat == DOTA_ATTRIBUTE_INTELLECT then
		caster:RemoveModifierByName("modifier_ernest_swap_int")
		caster:AddNewModifier(caster, self, "modifier_ernest_swap_agi", nil)
		caster:SetPrimaryAttribute(DOTA_ATTRIBUTE_AGILITY)
		-- caster:SwapAbilities("ernest_int1","ernest_agi1",false,true)
		-- caster:SwapAbilities("ernest_int2","ernest_agi2",false,true)
		-- caster:SwapAbilities("ernest_int3","ernest_agi3",false,true)

		ab1 = caster:GetAbilityByIndex(0):GetLevel()
		ab2 = caster:GetAbilityByIndex(1):GetLevel()
		ab3 = caster:GetAbilityByIndex(2):GetLevel()

		caster:RemoveAbility("ernest_int1")
		caster:RemoveAbility("ernest_int2")
		caster:RemoveAbility("ernest_int3")
		caster:AddAbility("ernest_agi1")
		caster:AddAbility("ernest_agi2")
		caster:AddAbility("ernest_agi3")

		caster:GetAbilityByIndex(0):SetLevel(ab1)
		caster:GetAbilityByIndex(1):SetLevel(ab2)
		caster:GetAbilityByIndex(2):SetLevel(ab3)
	end

	if stat == DOTA_ATTRIBUTE_AGILITY then
		caster:RemoveModifierByName("modifier_ernest_swap_agi")
		caster:AddNewModifier(caster, self, "modifier_ernest_swap_str", nil)
		caster:SetPrimaryAttribute(DOTA_ATTRIBUTE_STRENGTH)
		-- caster:SwapAbilities("ernest_agi1","ernest_str1",false,true)
		-- caster:SwapAbilities("ernest_agi2","ernest_str2",false,true)
		-- caster:SwapAbilities("ernest_agi3","ernest_str3",false,true)

		ab1 = caster:GetAbilityByIndex(0):GetLevel()
		ab2 = caster:GetAbilityByIndex(1):GetLevel()
		ab3 = caster:GetAbilityByIndex(2):GetLevel()

		caster:RemoveAbility("ernest_agi1")
		caster:RemoveAbility("ernest_agi2")
		caster:RemoveAbility("ernest_agi3")
		caster:AddAbility("ernest_str1")
		caster:AddAbility("ernest_str2")
		caster:AddAbility("ernest_str3")

		caster:GetAbilityByIndex(0):SetLevel(ab1)
		caster:GetAbilityByIndex(1):SetLevel(ab2)
		caster:GetAbilityByIndex(2):SetLevel(ab3)
	end

	if stat == DOTA_ATTRIBUTE_STRENGTH then
		caster:RemoveModifierByName("modifier_ernest_swap_str")
		caster:AddNewModifier(caster, self, "modifier_ernest_swap_int", nil)
		caster:SetPrimaryAttribute(DOTA_ATTRIBUTE_INTELLECT)
		-- caster:SwapAbilities("ernest_str1","ernest_int1",false,true)
		-- caster:SwapAbilities("ernest_str2","ernest_int2",false,true)
		-- caster:SwapAbilities("ernest_str3","ernest_int3",false,true)

		ab1 = caster:GetAbilityByIndex(0):GetLevel()
		ab2 = caster:GetAbilityByIndex(1):GetLevel()
		ab3 = caster:GetAbilityByIndex(2):GetLevel()

		caster:RemoveAbility("ernest_str1")
		caster:RemoveAbility("ernest_str2")
		caster:RemoveAbility("ernest_str3")
		caster:AddAbility("ernest_int1")
		caster:AddAbility("ernest_int2")
		caster:AddAbility("ernest_int3")

		caster:GetAbilityByIndex(0):SetLevel(ab1)
		caster:GetAbilityByIndex(1):SetLevel(ab2)
		caster:GetAbilityByIndex(2):SetLevel(ab3)
	end

	caster:CalculateStatBonus()
end

