ernest_agi2 = class({})

function ernest_agi2:DeclareVariables()
	local vars = {
		point,
		area_of_effect,
		caster,
	}
	return vars
end

function ernest_agi2:OnAbilityPinged()
	if IsServer() then
		caster = self:GetCaster()
		pID = caster:GetPlayerID()
		point = caster:GetCursorPosition()
		area_of_effect = self:GetSpecialValueFor("area_of_effect")
		print("ping: " .. point)

		if GridNav:IsNearbyTree( point, area_of_effect, true ) then
			print("Trees found")
		else
			print("Interrupted")
			caster:Interrupt()
		end
	end
end

function ernest_agi2:OnSpellStart()
	if IsServer() then		
		caster = self:GetCaster()
		point = caster:GetCursorPosition()
		area_of_effect = self:GetSpecialValueFor("area_of_effect")
		trees = GridNav:GetAllTreesAroundPoint( point, area_of_effect, true )
			
		for _,t in pairs(trees) do
			print("destroying tree")
			victims = FindUnitsInRadius(caster:GetTeamNumber(), t:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 0, 0, false)
			for _,v in pairs(victims) do
				print("applying damage")
				local damageTable = {
						victim = v,
						attacker = caster,
						damage = self:GetSpecialValueFor("damage"),
						damage_type = DAMAGE_TYPE_MAGICAL,
					}
				ApplyDamage(damageTable)
			end
			splinter_particle = ParticleManager:CreateParticle( "particles/splinter_leaf2.vpcf", PATTACH_WORLDORIGIN, nil )
				ParticleManager:SetParticleControl( splinter_particle, 0, t:GetAbsOrigin() )
			t:CutDown(caster:GetTeamNumber())			
		end
	end
end