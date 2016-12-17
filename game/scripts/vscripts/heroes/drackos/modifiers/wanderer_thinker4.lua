wanderer_thinker4 = class({})

LinkLuaModifier("modifier_spirits_tracker", "heroes/drackos/modifiers/modifier_spirits_tracker.lua", LUA_MODIFIER_MOTION_NONE)

function wanderer_thinker4:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.03)
		self:OnIntervalThink()
	end
end

function wanderer_thinker4:OnIntervalThink()
	thinker = self:GetParent()
	vLocation = thinker:GetAbsOrigin()
	print("vLocation: "..vLocation:__tostring())
	hAbility = self:GetAbility()
	hCaster = hAbility:GetCaster()
	speed = hAbility:GetSpecialValueFor("speed") * 0.03
	radius = hAbility:GetSpecialValueFor("target_lock_radius")
	lock_duration = hAbility:GetSpecialValueFor("lock_duration")
	vision_radius = hAbility:GetSpecialValueFor("vision_radius")

	AddFOWViewer(hCaster:GetTeamNumber(), vLocation, vision_radius, 0.2, true)

	local targets = FindUnitsInRadius(hCaster:GetTeamNumber(), vLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_CLOSEST, false)

	if targets ~= nil then
		hTarget = targets[1]
	else
		hTarget = nil
	end
	
	if vPoint == nil then
		math.randomseed(Time())
		local xRand = math.random(-7000, 7000)
		local yRand = math.random(-6500, 6500)
		vPoint = GetGroundPosition(Vector(xRand, yRand, 0), nil)
	end

	distTarget = nil
	distPoint = (vPoint-vLocation):Length()
	print("distPoint: "..distPoint)
	print("vPoint: "..vPoint:__tostring())
	vDirection = (vPoint-vLocation):Normalized()

	if hTarget ~= nil then
		vTarget = hTarget:GetAbsOrigin()
		distTarget = vTarget:Length(vLocation)
		vDirection = (vTarget-vLocation):Normalized()
	end

	thinker:SetAbsOrigin(GetGroundPosition(vLocation + vDirection * speed,nil))

	if distTarget ~= nil then
		if distTarget < 100 then
			hTarget:AddNewModifier(hCaster, hAbility, "modifier_spirits_tracker", {["duration"] = lock_duration})
			UTIL_Remove( thinker )
		end
	end

	if distPoint < 200 then
		math.randomseed(Time())
		local xRand = math.random(-7000, 7000)
		local yRand = math.random(-6500, 6500)
		vPoint = GetGroundPosition(Vector(xRand, yRand, 0), nil)
	end
end