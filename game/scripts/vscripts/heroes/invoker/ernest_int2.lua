ernest_int2 = class({})

function ernest_swap:OnSpellStart()
	caster = self:GetCaster()
	AddFOWViewer(caster:GetTeamNumber(), caster:GetCursorPosition(), self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("duration"), false)
	
	
	local damageTable = {
		victim = FindUnitsInRadius(entity:GetTeam(), caster:GetCursorPosition(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false ),
		attacker = caster,
		damage = self:GetAbility():GetSpecialValueFor("flat_damage"),
		damage_type = DAMAGE_TYPE_MAGICAL,
	}

	
	Timers:CreateTimer(1, function()
		ApplyDamage(damageTable)
	end)
	
end


FindUnitsInRadius(int teamNumber, Vector position, handle cacheUnit, float radius, int teamFilter, int typeFilter, int flagFilter, int order, bool canGrowCache)
Finds the units in a given radius with the given flags. ( iTeamNumber, vPosition, hCacheUnit, flRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, bCanGrowCache )