-- To Set This Up visit https://forum.cfx.re/t/how-to-updated-discord-rich-presence-custom-image/157686

local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    while true do
        -- This is the Application ID (Replace this with you own)
	SetDiscordAppId(992510653476655195)

        -- Here you will have to put the image name for the "large" icon.
	SetDiscordRichPresenceAsset('512-1')
        
        -- (11-11-2018) New Natives:

        -- Here you can add hover text for the "large" icon.
        SetDiscordRichPresenceAssetText('The British 50 Logo')
       
        -- Here you will have to put the image name for the "small" icon.
        SetDiscordRichPresenceAssetSmall('96-1')

        -- Here you can add hover text for the "small" icon.
        SetDiscordRichPresenceAssetSmallText('The British 50 Logo')

        QBCore.Functions.TriggerCallback('smallresources:server:GetCurrentPlayers', function(result)
            SetRichPresence('Players: '..result..'/36')
        end)

        -- (26-02-2021) New Native:
        
        --[[ 
            Here you can add buttons that will display in your Discord Status,
            First paramater is the button index (0 or 1), second is the title and 
            last is the url (this has to start with "fivem://connect/" or "https://") 
        ]]--
        SetDiscordRichPresenceAction(0, "Join Game!", "https://cfx.re/join/3xmyy8")
        SetDiscordRichPresenceAction(1, "Join Discord!", "https://discord.gg/british50")

        -- It updates every minute just in case.
	Wait(60000)
    end
end)