ernest_int2 = class({})

function ernest_int2:OnSpellStart()
	caster = self:GetCaster()
	AddFOWViewer(caster:GetTeamNumber(), caster:GetCursorPosition(), self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("duration"), false)
	
	local damageTable = {
		victim = FindUnitsInRadius(caster:GetOpposingTeamNumber(), caster:GetCursorPosition(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false ),
		attacker = caster,
		damage = self:GetSpecialValueFor("flat_damage"),
		damage_type = DAMAGE_TYPE_MAGICAL,
	}
	print(victim)
	Timers:CreateTimer(1, function()
		ApplyDamage(damageTable)
	end)
	
end