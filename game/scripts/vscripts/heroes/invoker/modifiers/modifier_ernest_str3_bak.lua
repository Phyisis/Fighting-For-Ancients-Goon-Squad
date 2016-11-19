modifier_ernest_str3 = class({})


function modifier_ernest_str3:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_STATE_CHANGED,
	}
	return funcs
end

function modifier_ernest_str3:OnCreated()	
	if IsServer() then
		target = self:GetParent():GetPlayerID()	
		exhaust_particle = ParticleManager:CreateParticle( "particles/evasion_blur.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControl( exhaust_particle, 0, self:GetParent():GetAbsOrigin())
	
		damagetohero = 0
		stunned = false
		ignoredamage = false
		ihd = PlayerResource:GetHeroDamageTaken(target, true)
		icd = PlayerResource:GetCreepDamageTaken(target, true)
		itd = PlayerResource:GetTowerDamageTaken(target, true)
	end
end

function modifier_ernest_str3:CheckState()
	if IsServer() then
		ability = self:GetAbility()
		threshold = ability:GetSpecialValueFor("damage_threshold")
		stun_duration = ability:GetSpecialValueFor("stun_duration")
		target = self:GetParent():GetPlayerID()
		
		chd = PlayerResource:GetHeroDamageTaken(target, true)
		ccd = PlayerResource:GetCreepDamageTaken(target, true)
		ctd = PlayerResource:GetTowerDamageTaken(target, true)
		if ignoredamage == false then
			damagetohero = (chd - ihd) + (ccd - icd) + (ctd - itd)  
		end
		print("totaldamage:" .. damagetohero)
		print("herodamage:" .. PlayerResource:GetHeroDamageTaken(target, true))
		print("creepdamage:" .. PlayerResource:GetCreepDamageTaken(target, true))
		print("towerdamage:" .. PlayerResource:GetTowerDamageTaken(target, true))

		if damagetohero > threshold then
			print("==========================================================stun applied=======================================================================")
			stun_particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_stunned.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
				ParticleManager:SetParticleControl( stun_particle, 0, self:GetParent():GetAbsOrigin():__add(Vector(0,0,100) ) )
			stunned = true
			state = {
				[MODIFIER_STATE_STUNNED] = stunned
			}
			ignoredamage = true
			damagetohero = 0
		end
	end
	return state
end

function modifier_ernest_str3:OnStateChanged()
	if IsServer() then
		if stunned == true then
			Timers:CreateTimer(stun_duration , function()
				state = {
					[MODIFIER_STATE_STUNNED] = false
				}
				print("----------------------------------------------------------stun removed-----------------------------------------------------------------------")
				ignoredamage = false
				ParticleManager:DestroyParticle(stun_particle, false)
				ihd = PlayerResource:GetHeroDamageTaken(target, true)
				icd = PlayerResource:GetCreepDamageTaken(target, true)
				itd = PlayerResource:GetTowerDamageTaken(target, true)
				stunned = false
			end)
		end
	end
	return state
end

function modifier_ernest_str3:IsPurgable()
	return true
end

function modifier_ernest_str3:GetTexture()
	return "ernest_str3"
end

function modifier_ernest_str3:IsDebuff()
	return true
end

function modifier_ernest_str3:OnDestroy()
	if IsServer() then 
		ParticleManager:DestroyParticle(exhaust_particle, false)
		state = {
			[MODIFIER_STATE_STUNNED] = false
		}
		ignoredamage = false
		ParticleManager:DestroyParticle(stun_particle, false)
		stunned = false
	end
end