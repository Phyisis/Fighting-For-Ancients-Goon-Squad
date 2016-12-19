modifier_vision = class({})

function modifier_vision:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.03)
		self:OnIntervalThink()
		Timers:CreateTimer(0, function()
			if not self:IsNull() then
				self:GetParent():EmitSound("eerie_souls")
				return 20
			end
		end)
		hAbility = self:GetAbility()
		hCaster = hAbility:GetCaster()
		Timers:CreateTimer(self:GetDuration()-0.1, function()
			print("decrementing tracker first")
			stacks = self:GetParent():GetModifierStackCount("modifier_spirits_tracker", hCaster)
			if stacks == 1 then
				self:GetParent():RemoveModifierByName("modifier_spirits_tracker")
			else
				self:GetParent():SetModifierStackCount("modifier_spirits_tracker", hCaster, stacks-1)
			end
		end)
	end
end

function modifier_vision:OnRefresh()
	hAbility = self:GetAbility()
	hCaster = hAbility:GetCaster()
	Timers:CreateTimer(self:GetDuration()-0.1, function()
		print("decrementing tracker subsequent")
		stacks = self:GetParent():GetModifierStackCount("modifier_spirits_tracker", hCaster)
		if stacks == 1 then
			self:GetParent():RemoveModifierByName("modifier_spirits_tracker")
		else
			self:GetParent():SetModifierStackCount("modifier_spirits_tracker", hCaster, stacks-1)
		end
	end)
end

function modifier_vision:OnIntervalThink()
	hAbility = self:GetAbility()
	hCaster = hAbility:GetCaster()
	vTarget = self:GetParent():GetAbsOrigin()
	AddFOWViewer(hCaster:GetTeamNumber(), vTarget, 10, 0.1, false)
end

function modifier_vision:GetEffectName()
	return "particles/spirit_projectile.vpcf"
end

function modifier_vision:GetTexture()
	return "spirit_vision"
end

function modifier_vision:OnDestroy()
	hAbility = self:GetAbility()
	hCaster = hAbility:GetCaster()
	print("decrementing tracker via destroy")
	stacks = self:GetParent():GetModifierStackCount("modifier_spirits_tracker", hCaster)
	if stacks == 1 then
		self:GetParent():RemoveModifierByName("modifier_spirits_tracker")
	else
		self:GetParent():SetModifierStackCount("modifier_spirits_tracker", hCaster, stacks-1)
	end
end