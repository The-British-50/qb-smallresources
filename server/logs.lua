local QBCore = exports['qb-core']:GetCoreObject()

local Webhooks = {
    ['pdarmory'] = 'https://discord.com/api/webhooks/1071813953564450856/Ks65DlCenjA_hdpHxCC3Lhep22GdV1QZR20rJKZlplzUXQR_6QLaEsvtIyeUqNHRRdWk',
    ['default'] = '',
    ['testwebhook'] = '',
    ['playermoney'] = '',
    ['playerinventory'] = '',
    ['robbing'] = 'https://discord.com/api/webhooks/1013858746734227566/QGT1rWlW1AsnE68yCvNnPH62pf7xV50mhWxOc811klF_f0PZVINdQZe4GLJKw3nb9HPd',
    ['cuffing'] = 'https://discord.com/api/webhooks/1013858746734227566/QGT1rWlW1AsnE68yCvNnPH62pf7xV50mhWxOc811klF_f0PZVINdQZe4GLJKw3nb9HPd',
    ['drop'] = '',
    ['trunk'] = '',
    ['stash'] = '',
    ['glovebox'] = '',
    ['banking'] = '',
    ['vehicleshop'] = 'https://discord.com/api/webhooks/1013858746734227566/QGT1rWlW1AsnE68yCvNnPH62pf7xV50mhWxOc811klF_f0PZVINdQZe4GLJKw3nb9HPd',
    ['vehicleupgrades'] = '',
    ['shops'] = '',
    ['dealers'] = 'https://discord.com/api/webhooks/1013858746734227566/QGT1rWlW1AsnE68yCvNnPH62pf7xV50mhWxOc811klF_f0PZVINdQZe4GLJKw3nb9HPd',
    ['storerobbery'] = 'https://discord.com/api/webhooks/1013858746734227566/QGT1rWlW1AsnE68yCvNnPH62pf7xV50mhWxOc811klF_f0PZVINdQZe4GLJKw3nb9HPd',
    ['bankrobbery'] = 'https://discord.com/api/webhooks/1013858746734227566/QGT1rWlW1AsnE68yCvNnPH62pf7xV50mhWxOc811klF_f0PZVINdQZe4GLJKw3nb9HPd',
    ['powerplants'] = '',
    ['death'] = '',
    ['joinleave'] = '',
    ['ooc'] = '',
    ['report'] = '',
    ['me'] = '',
    ['pmelding'] = '',
    ['112'] = '',
    ['bans'] = '',
    ['anticheat'] = '',
    ['weather'] = '',
    ['moneysafes'] = 'https://discord.com/api/webhooks/1013858746734227566/QGT1rWlW1AsnE68yCvNnPH62pf7xV50mhWxOc811klF_f0PZVINdQZe4GLJKw3nb9HPd',
    ['bennys'] = '',
    ['bossmenu'] = 'https://discord.com/api/webhooks/1013858746734227566/QGT1rWlW1AsnE68yCvNnPH62pf7xV50mhWxOc811klF_f0PZVINdQZe4GLJKw3nb9HPd',
    ['robbery'] = 'https://discord.com/api/webhooks/1013858746734227566/QGT1rWlW1AsnE68yCvNnPH62pf7xV50mhWxOc811klF_f0PZVINdQZe4GLJKw3nb9HPd',
    ['casino'] = '',
    ['traphouse'] = 'https://discord.com/api/webhooks/1013858746734227566/QGT1rWlW1AsnE68yCvNnPH62pf7xV50mhWxOc811klF_f0PZVINdQZe4GLJKw3nb9HPd',
    ['911'] = '',
    ['palert'] = 'https://discord.com/api/webhooks/1013858746734227566/QGT1rWlW1AsnE68yCvNnPH62pf7xV50mhWxOc811klF_f0PZVINdQZe4GLJKw3nb9HPd',
    ['house'] = 'https://discord.com/api/webhooks/1013858746734227566/QGT1rWlW1AsnE68yCvNnPH62pf7xV50mhWxOc811klF_f0PZVINdQZe4GLJKw3nb9HPd',
    ['trust-suspicious'] = 'https://discord.com/api/webhooks/1007760884996775956/oHp6q63SW6ZueP3T_eewj5idLAfev9lFIR2KkWZZzz8iD5DYVQbL8yLaQhE1oKKwOjrc',
    ['trust-new-player-suspicious'] = 'https://discord.com/api/webhooks/1007760891170799747/ieTftj0Nwyy7hdh54Agk4bOx_OYWpjPsyuUOpF1DT2T50Hh55n44DFYtsq_OGTPFGwG7',
}

local Colors = { -- https://www.spycolor.com/
    ['default'] = 14423100,
    ['blue'] = 255,
    ['red'] = 16711680,
    ['green'] = 65280,
    ['white'] = 16777215,
    ['black'] = 0,
    ['orange'] = 16744192,
    ['yellow'] = 16776960,
    ['pink'] = 16761035,
    ["lightgreen"] = 65309,
}

RegisterNetEvent('qb-log:server:CreateLog', function(name, title, color, message, tagEveryone)
    local tag = tagEveryone or false
    local webHook = Webhooks[name] or Webhooks['default']
    local embedData = {
        {
            ['title'] = title,
            ['color'] = Colors[color] or Colors['default'],
            ['footer'] = {
                ['text'] = os.date('%c'),
            },
            ['description'] = message,
            ['author'] = {
                ['name'] = 'British 50 Logs',
                ['icon_url'] = 'https://media.discordapp.net/attachments/870094209783308299/870104331142189126/Logo_-_Display_Picture_-_Stylized_-_Red.png?width=670&height=670',
            },
        }
    }
    PerformHttpRequest(webHook, function() end, 'POST', json.encode({ username = 'QB Logs', embeds = embedData}), { ['Content-Type'] = 'application/json' })
    Citizen.Wait(100)
    if tag then
        PerformHttpRequest(webHook, function() end, 'POST', json.encode({ username = 'QB Logs', content = '@everyone'}), { ['Content-Type'] = 'application/json' })
    end
end)

QBCore.Commands.Add('testwebhook', 'Test Your Discord Webhook For Logs (God Only)', {}, false, function()
    TriggerEvent('qb-log:server:CreateLog', 'testwebhook', 'Test Webhook', 'default', 'Webhook setup successfully')
end, 'god')
