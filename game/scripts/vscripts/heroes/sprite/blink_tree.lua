blink_tree = class({})

function blink_tree:OnSpellStart()
	print("CREATED")
	ability = self:GetAbility()
	caster = self:GetParent()
	caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
	print("can fly")
		
	Timers:CreateTimer(500, function()
		
		caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
		
	end)
end
--------------------------------------------------------------------------------
 
function blink_tree:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
 
--------------------------------------------------------------------------------
 
function blink_tree:CastFilterResultTarget( hTarget )
	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end
 
	if ( hTarget:IsCreep() and ( not self:GetCaster():HasScepter() ) ) or hTarget:IsAncient() then
		return UF_FAIL_CUSTOM
	end
 
	local nResult = UnitFilter( hTarget, DOTA_UNIT_TARGET_TEAM_NONE, DOTA_UNIT_TARGET_TREE, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber() )
	if nResult ~= UF_SUCCESS then
		return nResult
	end
 
	return UF_SUCCESS
end
 
--------------------------------------------------------------------------------
 
function blink_tree:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end
 
	if hTarget:IsAncient() then
		return "#dota_hud_error_cant_cast_on_ancient"
	end
 
	if hTarget:IsCreep() and ( not self:GetCaster():HasScepter() ) then
		return "#dota_hud_error_cant_cast_on_creep"
	end
 
	return ""
end
 
--------------------------------------------------------------------------------
 
function blink_tree:GetCooldown( nLevel )
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor( "blink_tree_cooldown_scepter" )
	end
 
	return self.BaseClass.GetCooldown( self, nLevel )
end
 
--------------------------------------------------------------------------------
 
function blink_tree:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	
	print("CREATED")
	hCaster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
	print("can fly")
		
	Timers:CreateTimer(5, function()
		
		hCaster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
		FindClearSpaceForUnit( hCaster, hCaster:GetOrigin(), true )
		
	end)
 
	local vPos2 = hTarget:GetOrigin()
 
	hCaster:SetOrigin( vPos2 )
 
	FindClearSpaceForUnit( hCaster, vPos2, true )
	
	local nCasterFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster )
	ParticleManager:SetParticleControlEnt( nCasterFX, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), false )
	ParticleManager:ReleaseParticleIndex( nCasterFX )
 
	EmitSoundOn( "Hero_VengefulSpirit.NetherSwap", hCaster )
 
	hCaster:StartGesture( ACT_DOTA_CHANNEL_END_ABILITY_4 )
end