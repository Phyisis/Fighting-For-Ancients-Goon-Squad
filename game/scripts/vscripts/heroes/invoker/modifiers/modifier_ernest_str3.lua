modifier_ernest_str3 = class({})

LinkLuaModifier("modifier_stunned", LUA_MODIFIER_MOTION_NONE)

function modifier_ernest_str3:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_STATE_CHANGED,
	}
	return funcs
end

function modifier_ernest_str3:OnCreated()	
	if IsServer() then
		target = self:GetParent():GetPlayerID()	
		exhaust_particle = ParticleManager:CreateParticle( "particles/fire_stun.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
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

		if damagetohero > threshold and stunned == false then
			print("==========================================================stun applied=======================================================================")
			stunned = true
			self:GetParent():AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
			ignoredamage = true
			damagetohero = 0
		end
	end
end

function modifier_ernest_str3:OnStateChanged()
	if IsServer() then
		if stunned == true then
			Timers:CreateTimer(stun_duration , function()
				print("----------------------------------------------------------stun removed-----------------------------------------------------------------------")	
				ihd = PlayerResource:GetHeroDamageTaken(target, true)
				icd = PlayerResource:GetCreepDamageTaken(target, true)
				itd = PlayerResource:GetTowerDamageTaken(target, true)				
				ignoredamage = false
				stunned = false
			end)
		end
	end
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
		stunned = false
	end
end