modifier_wanderer = class({})

LinkLuaModifier("modifier_spirits_tracker", "heroes/drackos/modifiers/modifier_spirits_tracker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_vision", "heroes/drackos/modifiers/modifier_vision.lua", LUA_MODIFIER_MOTION_NONE)

function modifier_wanderer:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.03)
		self:OnIntervalThink()
		Timers:CreateTimer(0, function()
			if not self:IsNull() then
				self:GetParent():EmitSound("eerie_souls")
				return 20
			end
		end)
	end
end

function modifier_wanderer:CheckState()
	state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_NO_TEAM_MOVE_TO] = true,
        [MODIFIER_STATE_NO_TEAM_SELECT] = true,
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        --[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
	return state
end

function modifier_wanderer:OnIntervalThink()
	thinker = self:GetParent()
	vLocation = thinker:GetAbsOrigin()
	hAbility = self:GetAbility()
	if not hAbility:IsNull() then
		hCaster = hAbility:GetCaster()
		speed = hAbility:GetSpecialValueFor("speed") * 0.03
		radius = hAbility:GetSpecialValueFor("target_lock_radius")
		lock_duration = hAbility:GetSpecialValueFor("lock_duration")
		vision_radius = hAbility:GetSpecialValueFor("vision_radius")

		AddFOWViewer(hCaster:GetTeamNumber(), vLocation, vision_radius, 1.0, true)

		local targets = FindUnitsInRadius(hCaster:GetTeamNumber(), vLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_CLOSEST, false)

		if targets ~= nil then
			hTarget = targets[1]
		else
			hTarget = nil
		end

		if thinker.vPoint == nil then
			math.randomseed(vLocation:Length()+Time())
			local xRand = math.random(-7000, 7000)
			local yRand = math.random(-6500, 6500)
			thinker.vPoint = GetGroundPosition(Vector(xRand, yRand, 0), nil)
		end

		distTarget = nil
		distPoint = (thinker.vPoint-vLocation):Length()
		vDirection = (thinker.vPoint-vLocation):Normalized()

		if hTarget ~= nil then
			vTarget = hTarget:GetAbsOrigin()
			distTarget = (vTarget-vLocation):Length()
			vDirection = (vTarget-vLocation):Normalized()
		end

		thinker:SetAbsOrigin(GetGroundPosition(vLocation + vDirection * speed, nil))

		if distTarget ~= nil then
			if distTarget < 100 then
				if hCaster:HasScepter() then
					if hTarget:HasModifier("modifier_spirits_tracker") then
						print("incrementing tracker")
						stacks = hTarget:GetModifierStackCount("modifier_spirits_tracker", hCaster)
						hTarget:SetModifierStackCount("modifier_spirits_tracker", hCaster, stacks+1)
					else
						print("adding tracker")
						hTarget:AddNewModifier(hCaster, hAbility, "modifier_spirits_tracker", nil)
						hTarget:SetModifierStackCount("modifier_spirits_tracker", hCaster, 1)
					end
				end
				hTarget:AddNewModifier(hCaster, hAbility, "modifier_vision", {["duration"] = lock_duration})
				thinker:SetAbsOrigin(vLocation:__add(Vector(0,0,-500)))
				thinker:ForceKill(false)
			end
		end

		if distPoint < 200 then
			math.randomseed(vLocation:Length()+Time())
			local xRand = math.random(-7000, 7000)
			local yRand = math.random(-6500, 6500)
			thinker.vPoint = GetGroundPosition(Vector(xRand, yRand, 0), nil)
		end
	end
end

function modifier_wanderer:OnDestroy()
	soulstacks = hCaster:GetModifierStackCount("modifier_souls_tracker", hCaster)
	hCaster:SetModifierStackCount("modifier_souls_tracker", hCaster, soulstacks-1)
	self:GetParent():ForceKill(false)
end