modifier_wallet_drain_lua = class({})

if IsServer() then

	function modifier_wallet_drain_lua:OnCreated()

		--self:GetParent():Interrupt()
		self:StartIntervalThink(0.25)
		self:OnIntervalThink()
		ability = self:GetAbility()
		target = ability:GetCursorTarget()

		StartSoundEvent("Hero_Lion.ManaDrain", target)

	end

	function modifier_wallet_drain_lua:OnIntervalThink()
		
		ability = self:GetAbility()
		caster = self:GetCaster()
		target = ability:GetCursorTarget()

		-- If its an illusion then kill it
		if target:IsIllusion() then
			target:ForceKill(true)
			caster:Stop()
		else
			-- Location variables
			local caster_location = caster:GetAbsOrigin()
			local target_location = target:GetAbsOrigin()

			-- Distance variables
			local distance = (target_location - caster_location):Length2D()
			local break_distance = ability:GetLevelSpecialValueFor("break_distance", (ability:GetLevel() - 1))
			local direction = (target_location - caster_location):Normalized()

			-- If the leash is broken then stop the channel
			if distance >= break_distance then
				ability:OnChannelFinish(false)
				caster:Stop()
				return
			end

			-- Make sure that the caster always faces the target
			caster:SetForwardVector(direction)

			-- Gold calculation
			local gold_per_second = ability:GetLevelSpecialValueFor("gold_per_second", (ability:GetLevel() - 1))
			local tick_interval = ability:GetLevelSpecialValueFor("tick_interval", (ability:GetLevel() - 1))
			local gold_drain = gold_per_second / (1 / tick_interval)

			local target_gold = PlayerResource:GetUnreliableGold(target:GetPlayerID())

			-- Gold drain part
			-- If the target has enough mana then drain the maximum amount
			-- otherwise drain whatever is left
			if target_gold >= gold_drain then
				PlayerResource:ModifyGold(target:GetPlayerID(), -gold_drain, false, 0)
				PlayerResource:ModifyGold(caster:GetPlayerID(), gold_drain, false, 0)
			else
				PlayerResource:ModifyGold(target:GetPlayerID(), -target_gold, false, 0)
				PlayerResource:ModifyGold(caster:GetPlayerID(), target_gold, false, 0)
			end
		end

		local midas_particle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)	
		ParticleManager:SetParticleControlEnt(midas_particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)

	end

	function modifier_wallet_drain_lua:OnDestroy()

		ability = self:GetAbility()
		target = ability:GetCursorTarget()
		StopSoundEvent("Hero_Lion.ManaDrain", target)

	end


end

function modifier_wallet_drain_lua:DeclareFunctions()
	
	local funcs = {}

	return funcs
end