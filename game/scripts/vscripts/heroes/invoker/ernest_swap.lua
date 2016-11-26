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

		ab1 = caster:GetAbilityByIndex(0):GetLevel()
		ab2 = caster:GetAbilityByIndex(1):GetLevel()
		ab3 = caster:GetAbilityByIndex(2):GetLevel()

		caster:GetAbilityByIndex(0):SetHidden(true)
		caster:GetAbilityByIndex(1):SetHidden(true)
		caster:GetAbilityByIndex(2):SetHidden(true)
		caster:GetAbilityByIndex(3):SetHidden(false)
		caster:GetAbilityByIndex(4):SetHidden(false)
		caster:GetAbilityByIndex(5):SetHidden(false)
	
		caster:GetAbilityByIndex(3):SetLevel(ab1)
		caster:GetAbilityByIndex(4):SetLevel(ab2)
		caster:GetAbilityByIndex(5):SetLevel(ab3)
	end

	if stat == DOTA_ATTRIBUTE_AGILITY then
		caster:RemoveModifierByName("modifier_ernest_swap_agi")
		caster:AddNewModifier(caster, self, "modifier_ernest_swap_str", nil)
		caster:SetPrimaryAttribute(DOTA_ATTRIBUTE_STRENGTH)

		ab1 = caster:GetAbilityByIndex(3):GetLevel()
		ab2 = caster:GetAbilityByIndex(4):GetLevel()
		ab3 = caster:GetAbilityByIndex(5):GetLevel()
		
		caster:GetAbilityByIndex(3):SetHidden(true)
		caster:GetAbilityByIndex(4):SetHidden(true)
		caster:GetAbilityByIndex(5):SetHidden(true)
		caster:GetAbilityByIndex(6):SetHidden(false)
		caster:GetAbilityByIndex(7):SetHidden(false)
		caster:GetAbilityByIndex(8):SetHidden(false)
		
		caster:GetAbilityByIndex(6):SetLevel(ab1)
		caster:GetAbilityByIndex(7):SetLevel(ab2)
		caster:GetAbilityByIndex(8):SetLevel(ab3)
	end

	if stat == DOTA_ATTRIBUTE_STRENGTH then
		caster:RemoveModifierByName("modifier_ernest_swap_str")
		caster:AddNewModifier(caster, self, "modifier_ernest_swap_int", nil)
		caster:SetPrimaryAttribute(DOTA_ATTRIBUTE_INTELLECT)

		ab1 = caster:GetAbilityByIndex(6):GetLevel()
		ab2 = caster:GetAbilityByIndex(7):GetLevel()
		ab3 = caster:GetAbilityByIndex(8):GetLevel()

		caster:GetAbilityByIndex(6):SetHidden(true)
		caster:GetAbilityByIndex(7):SetHidden(true)
		caster:GetAbilityByIndex(8):SetHidden(true)
		caster:GetAbilityByIndex(0):SetHidden(false)
		caster:GetAbilityByIndex(1):SetHidden(false)
		caster:GetAbilityByIndex(2):SetHidden(false)
				
		caster:GetAbilityByIndex(0):SetLevel(ab1)
		caster:GetAbilityByIndex(1):SetLevel(ab2)
		caster:GetAbilityByIndex(2):SetLevel(ab3)
	end

	caster:CalculateStatBonus()
end