modifier_lantern = class({})

LinkLuaModifier("generic_thinker", "heroes/invoker/modifiers/generic_thinker.lua", LUA_MODIFIER_MOTION_NONE)

function modifier_lantern:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.04)
		--print("created")
	end
end

function modifier_lantern:OnIntervalThink()
	if IsServer() then
		caster = self:GetParent()
		caster_pos = caster:GetAbsOrigin()
		target_exists = false
		
		if caster:IsRealHero() then
		
			all_heroes = HeroList:GetAllHeroes()
			for _,h in pairs(all_heroes) do
				if h:GetTeam() ~= caster:GetTeam() and h:IsAlive() then
					target_exists = true
				end
			end
				
			if target_exists == true then
			
				units = FindUnitsInRadius(caster:GetTeam(), caster_pos, nil, 100000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
				closest_enemy = units[1]
				dist_closest = math.floor(CalcDistanceBetweenEntityOBB(caster, closest_enemy))
					
					if dist_closest < 500 then 
						red = 0.95
						green = 0.05
						blue = 0.05
					elseif dist_closest > 5000 then
						red = 0.05
						green = 0.05
						blue = 0.95
					else
						red = (-0.0002*dist_closest + 1.05)
						green = 0.05
						blue = (0.0002*dist_closest - 0.05)
					end				
										
				angle = (closest_enemy:GetAbsOrigin():__sub(caster_pos)):Normalized()
				--print(angle)
				target_pos = caster_pos:__add( 200*angle )
				
				local thinker = CreateModifierThinker(caster, self:GetAbility(), "generic_thinker", {["duration"] = 0.35}, target_pos, caster:GetTeamNumber(), false)
				
				if caster:HasModifier("modifier_water_fiend") then 
					AddFOWViewer(caster:GetTeamNumber(), target_pos, self:GetAbility():GetSpecialValueFor("vision"), 0.5, false)				
								
					victims = nil
					victims = FindUnitsInRadius(caster:GetTeam(), target_pos, nil, 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
								
					for _,v in pairs(victims) do
						local damageTable = {
							victim = v,
							attacker = caster,
							damage = self:GetAbility():GetSpecialValueFor("damage")/25,
							damage_type = DAMAGE_TYPE_PURE,
						}
						ApplyDamage(damageTable)
					end
					if victims[1] ~= nil then 
						local zap_particle = ParticleManager:CreateParticle("particles/lantern_zap.vpcf", PATTACH_ABSORIGIN, thinker)	
							ParticleManager:SetParticleControl(zap_particle, 0, thinker:GetAbsOrigin():__add(Vector(0,0,100)))
							ParticleManager:SetParticleControl(zap_particle, 1, Vector(red, green, blue) )
					end
				end				
								
				local lantern_particle = ParticleManager:CreateParticle("particles/lantern.vpcf", PATTACH_ABSORIGIN, thinker)	
					ParticleManager:SetParticleControl(lantern_particle, 0, thinker:GetAbsOrigin():__add(Vector(0,0,100)))
					ParticleManager:SetParticleControl(lantern_particle, 1, Vector(red,green,blue) )
								
			end
		end
	end
end

function modifier_lantern:GetTexture()
	return "lantern"
end

function modifier_lantern:AllowIllusionDuplicate()
	return true
end

function modifier_lantern:IsPurgable()
	return false
end

function modifier_lantern:IsHidden()
	return false
end