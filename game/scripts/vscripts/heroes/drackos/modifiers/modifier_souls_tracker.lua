modifier_souls_tracker = class({})

LinkLuaModifier("wanderer_thinker1", "heroes/drackos/modifiers/wanderer_thinker1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("wanderer_thinker2", "heroes/drackos/modifiers/wanderer_thinker2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("wanderer_thinker3", "heroes/drackos/modifiers/wanderer_thinker3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("wanderer_thinker4", "heroes/drackos/modifiers/wanderer_thinker4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wanderer", "heroes/drackos/modifiers/modifier_wanderer.lua", LUA_MODIFIER_MOTION_NONE)

function modifier_souls_tracker:OnCreated()
	hAbility = self:GetAbility()
	hCaster = self:GetParent()
	sDuration = hAbility:GetSpecialValueFor("duration")
	souls = hAbility:GetSpecialValueFor("souls")	
	waitTime = sDuration/(4*souls)
	if IsServer() then
		self:StartIntervalThink(waitTime)
		self:OnIntervalThink()
	end
	hCaster:SetModifierStackCount("modifier_souls_tracker", hCaster, 1)
end

function modifier_souls_tracker:OnIntervalThink()
	hAbility = self:GetAbility()
	sDuration = hAbility:GetSpecialValueFor("duration")
	hCaster = self:GetParent()
	intTeam = hCaster:GetTeamNumber()

	if operate == nil then 
		operate = true
	else 
		operate = nil
	end

	if hCaster:HasScepter() then
		operate = true
	end

	if operate == true then
		soulstacks = hCaster:GetModifierStackCount("modifier_souls_tracker", hCaster)
		hCaster:SetModifierStackCount("modifier_souls_tracker", hCaster, soulstacks+1)

		if intTeam == DOTA_TEAM_GOODGUYS then
			vSpawn = Vector(-7326.586914, -6807.351563, 512.000000)
		else
			vSpawn = Vector(7203.612793, 6621.416504, 512.000000)
		end

		if IsServer() then
			local dummy_unit = CreateUnitByName('npc_dummy_unit', vSpawn, false, nil, nil, intTeam) 
			dummy_unit:AddNewModifier(hCaster, hAbility, "modifier_wanderer", {["duration"] = sDuration})
			local spirit_particle = ParticleManager:CreateParticle("particles/spirit_projectile.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy_unit)	
				ParticleManager:SetParticleControl(spirit_particle, 0, dummy_unit:GetAbsOrigin())
		end
	end
end