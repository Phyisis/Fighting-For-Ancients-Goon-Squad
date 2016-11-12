jew_claw_lua = class({})

function jew_claw_lua:OnSpellStart()

	caster = self:GetCaster()
	target = self:GetCursorTarget()

	target:EmitSound("DOTA_Item.Hand_Of_Midas")

	local midas_particle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)	
	ParticleManager:SetParticleControlEnt(midas_particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)

	gold = self:GetSpecialValueFor("gold_bonus")
	xp = self:GetSpecialValueFor("xp_bonus")

	target:SetDeathXP(math.floor(target:GetDeathXP() * xp))
	target:SetMinimumGoldBounty(gold)
	target:SetMaximumGoldBounty(gold)
	target:Kill(self, caster)

end