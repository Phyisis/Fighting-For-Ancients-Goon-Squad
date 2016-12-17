modifier_souls_tracker = class({})

LinkLuaModifier("wanderer_thinker1", "heroes/drackos/modifiers/wanderer_thinker1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("wanderer_thinker2", "heroes/drackos/modifiers/wanderer_thinker2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("wanderer_thinker3", "heroes/drackos/modifiers/wanderer_thinker3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("wanderer_thinker4", "heroes/drackos/modifiers/wanderer_thinker4.lua", LUA_MODIFIER_MOTION_NONE)

function modifier_souls_tracker:OnCreated()
	hAbility = self:GetAbility()
	sDuration = hAbility:GetSpecialValueFor("duration")
	souls = hAbility:GetSpecialValueFor("souls")
	waitTime = sDuration/souls
	if IsServer() then
		self:StartIntervalThink(waitTime)
		self:OnIntervalThink()
	end
end

function modifier_souls_tracker:OnIntervalThink()
	hAbility = self:GetAbility()
	sDuration = hAbility:GetSpecialValueFor("duration")
	hCaster = self:GetParent()
	intTeam = hCaster:GetTeamNumber()

	if i == nil then
		i = 0
	end

	if intTeam == DOTA_TEAM_GOODGUYS then
		vSpawn = Vector(-7326.586914, -6807.351563, 512.000000)
	else
		vSpawn = Vector(7203.612793, 6621.416504, 512.000000)
	end

	if IsServer() then
		if i == 4 then
			i = 0
		end
		i = i + 1
		local thinker = CreateModifierThinker(hCaster, hAbility, "wanderer_thinker"..i, {["duration"] = sDuration+3}, vSpawn, intTeam, false)
		local spirit_particle = ParticleManager:CreateParticle("particles/spirit_projectile.vpcf", PATTACH_ABSORIGIN_FOLLOW, thinker)	
			ParticleManager:SetParticleControl(spirit_particle, 0, thinker:GetAbsOrigin())

		thinker:EmitSound("Hero_Bane.Nightmare.Loop")
	end
end