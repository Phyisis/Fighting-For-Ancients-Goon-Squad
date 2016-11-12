-- Generated from template

if FAGSDota == nil then
	FAGSDota = class({})
end

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = FAGSDota()
	GameRules.AddonTemplate:InitGameMode()
end

function FAGSDota:InitGameMode()
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )

	ListenToGameEvent( "player_chat", Dynamic_Wrap( FAGSDota, 'OnChat' ), self )


end

-- Evaluate the state of the game
function FAGSDota:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function FAGSDota:OnChat(event)
	if event.text == 'spawnbots' then
		self:EnableBots()
	end
	if event.text == 'debug' then
		self:EzDebug()
	end
end

function FAGSDota:EzDebug()
	SendToConsole("lvlup 25")
	SendToConsole("item travel 2; item heart; item butter; item skadi")
end


function FAGSDota:EnableBots()

	SendToServerConsole("sv_cheats 1; dota_bot_populate")
	GameRules:GetGameModeEntity():SetBotsAlwaysPushWithHuman( false )
	GameRules:GetGameModeEntity():SetBotsInLateGame( false )
	GameRules:GetGameModeEntity():SetBotsMaxPushTier( 4 )
	GameRules:GetGameModeEntity():SetBotThinkingEnabled( true )

	for _, hero in pairs( HeroList:GetAllHeroes() ) do
		hero:SetBotDifficulty(4)
	end

end