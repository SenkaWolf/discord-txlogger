-- functions --
local function log(level, msg)
    local colors = { error = '^1', success = '^2', info = '^5' }
    print('['..colors[level]..level:upper()..'^7] '..msg)
end

local function createEmbed(title, description, color, extraFields)
    local embed = {
        title = title,
        description = description,
        color = tonumber(color:gsub('#', ''), 16),
        footer = { ['text'] = Config.FooterText },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%S"),
        fields = extraFields
    }
    return embed
end

local function isValidWebhookUrl(url)
    return url:find('https://') and url:find('discord')
end

local function SendDiscordWebhook(webhookData)
    if not isValidWebhookUrl(webhookData.url) then
        return log('error', 'Invalid discord webhook url: ' .. webhookData.url)
    end

    PerformHttpRequest(webhookData.url, function(code)
        if code ~= 204 then
            log('error', 'Error sending webhook: ' .. tostring(code))
        end
    end, 'POST', json.encode({
        username = webhookData.botName,
        avatar_url = webhookData.botAvatarUrl,
        embeds = { webhookData.embed }
    }), { ['Content-Type'] = 'application/json' })
end

-- players events --
AddEventHandler('txAdmin:events:playerWarned', function(eventData)
    local embed = createEmbed(
        'Player warned',
        '**Event: `txAdmin:events:playerWarned`**',
        '#DFFF00', {
            { name = 'Player', value = '**`['..eventData.target..'] '..GetPlayerName(eventData.target)..'`**', inline = true },
            { name = 'Author', value = '**`'..eventData.author..'`**', inline = true },
            { name = 'Reason', value = '**`'..eventData.reason..'`**', inline = true },
            { name = 'Action Id', value = '**`'..eventData.actionId..'`**', inline = true }
        }
    )

    SendDiscordWebhook({
        url = Config.WebHooks['Players'],
        embed = embed,
        botName = "txAdmin Player Log",
        botAvatarUrl = "https://corepixelrp.net/assets/img/external/logs/logo-log.png"
    })
end)

AddEventHandler('txAdmin:events:playerKicked', function(eventData)
    local embed = createEmbed(
        'Player kicked',
        '**Event: `txAdmin:events:playerKicked`**',
        '#FFBF00', {
            { name = 'Player', value = '**`['..eventData.target..'] '..GetPlayerName(eventData.target)..'`**', inline = true },
            { name = 'Author', value = '**`'..eventData.author..'`**', inline = true },
            { name = 'Reason', value = '**`'..eventData.reason..'`**', inline = true }
        }
    )

    SendDiscordWebhook({
        url = Config.WebHooks['Players'],
        embed = embed,
        botName = "txAdmin Player Log",
        botAvatarUrl = "https://corepixelrp.net/assets/img/external/logs/logo-log.png"
    })
end)

AddEventHandler('txAdmin:events:playerBanned', function(eventData)
    eventData.durationTranslated = eventData.durationTranslated or 'Permanent'

    local embed = createEmbed(
        'Player banned',
        '**Event: `txAdmin:events:playerBanned`**',
        '#FF0000', {
            { name = 'Player', value = '**`'..eventData.targetName..'`**', inline = true },
            { name = 'Author', value = '**`'..eventData.author..'`**', inline = true },
            { name = 'Reason', value = '**`'..eventData.reason..'`**', inline = true },
            { name = 'Duration', value = '**`'..eventData.durationTranslated..'`**', inline = true },
            { name = 'Action Id', value = '**`'..eventData.actionId..'`**', inline = true }
        }
    )

    SendDiscordWebhook({
        url = Config.WebHooks['Players'],
        embed = embed,
        botName = "txAdmin Player Log",
        botAvatarUrl = "https://corepixelrp.net/assets/img/external/logs/logo-log.png"
    })
end)

AddEventHandler('txAdmin:events:healedPlayer', function(eventData)
    local playerName = eventData.id ~= -1 and '**`['..eventData.id..'] '..GetPlayerName(eventData.id)..'`**' or '**`Everyone`**'

    local embed = createEmbed(
        'Player healed',
        '**Event: `txAdmin:events:healedPlayer`**',
        '#9FE2BF', {
            { name = 'Player', value = playerName, inline = true }
        }
    )

    SendDiscordWebhook({
        url = Config.WebHooks['Players'],
        embed = embed,
        botName = "txAdmin Player Log",
        botAvatarUrl = "https://corepixelrp.net/assets/img/external/logs/logo-log.png"
    })
end)

AddEventHandler('txAdmin:events:actionRevoked', function(eventData)
    local embed = createEmbed(
        'Action revoked',
        '**Event: `txAdmin:events:actionRevoked`**',
        '#DE3163', {
            { name = 'Player', value = '**`'..eventData.playerName..'`**', inline = true },
            { name = 'Action Id', value = '**`'..eventData.actionId..'`**', inline = true },
            { name = 'Action type', value = '**`'..eventData.actionType..'`**', inline = true },
            { name = 'Action reason', value = '**`'..eventData.actionReason..'`**', inline = true },
            { name = 'Revoked by', value = '**`'..eventData.revokedBy..'`**', inline = true }
        }
    )

    SendDiscordWebhook({
        url = Config.WebHooks['Players'],
        embed = embed,
        botName = "txAdmin Player Log",
        botAvatarUrl = "https://corepixelrp.net/assets/img/external/logs/logo-log.png"
    })
end)

AddEventHandler('txAdmin:events:whitelistPlayer', function(eventData)
    local embed = createEmbed(
        'Whitelist player',
        '**Event: `txAdmin:events:whitelistPlayer`**',
        '#9FE2BF', {
            { name = 'Player', value = '**`'..eventData.playerName..'`**', inline = true },
            { name = 'Action', value = '**`'..eventData.action..'`**', inline = true },
            { name = 'Admin', value = '**`'..eventData.adminName..'`**', inline = true }
        }
    )

    SendDiscordWebhook({
        url = Config.WebHooks['Players'],
        embed = embed,
        botName = "txAdmin Player Log",
        botAvatarUrl = "https://corepixelrp.net/assets/img/external/logs/logo-log.png"
    })
end)

AddEventHandler('txAdmin:events:whitelistRequest', function(eventData)
    local embed = createEmbed(
        'Whitelist request',
        '**Event: `txAdmin:events:whitelistRequest`**',
        '#6495ED', {
            { name = 'Player', value = '**`'..eventData.playerName..'`**', inline = true },
            { name = 'Action', value = '**`'..eventData.action..'`**', inline = true },
            { name = 'Request Id', value = '**`'..eventData.requestId..'`**', inline = true }
        }
    )

    SendDiscordWebhook({
        url = Config.WebHooks['Players'],
        embed = embed,
        botName = "txAdmin Player Log",
        botAvatarUrl = "https://corepixelrp.net/assets/img/external/logs/logo-log.png"
    })
end)

AddEventHandler('txAdmin:events:whitelistPreApproval', function(eventData)
    local player = eventData.playerName or eventData.identifier
    local embed = createEmbed(
        'Whitelist pre approval',
        '**Event: `txAdmin:events:whitelistPreApproval`**',
        '#DFFF00', {
            { name = 'Player', value = '**`'..player..'`**', inline = true },
            { name = 'Action', value = '**`'..eventData.action..'`**', inline = true },
            { name = 'Admin', value = '**`'..eventData.adminName..'`**', inline = true }
        }
    )

    SendDiscordWebhook({
        url = Config.WebHooks['Players'],
        embed = embed,
        botName = "txAdmin Server Log",
        botAvatarUrl = "https://corepixelrp.net/assets/img/external/logs/logo-log.png"
    })
end)

-- server events --
RegisterServerEvent('txAdmin:events:announcement', function(eventData)
    local embed = createEmbed(
        'Announcement',
        '**Event: `txAdmin:events:announcement`**',
        '#40E0D0', {
            { name = 'Author', value = '**`'..eventData.author..'`**', inline = true },
            { name = 'Message', value = '**`'..eventData.message..'`**', inline = true }
        }
    )

    SendDiscordWebhook({
        url = Config.WebHooks['Server'],
        embed = embed,
        botName = "txAdmin Server Log",
        botAvatarUrl = "https://corepixelrp.net/assets/img/external/logs/logo-log.png"
    })
end)

AddEventHandler('txAdmin:events:serverShuttingDown', function(eventData)
    local embed = createEmbed(
        'Server shutting down',
        '**Event: `txAdmin:events:serverShuttingDown`**',
        '#DFFF00', {
            { name = 'Author', value = '**`'..eventData.author..'`**', inline = true },
            { name = 'Message', value = '**`'..eventData.message..'`**', inline = true }
        }
    )

    SendDiscordWebhook({
        url = Config.WebHooks['Server'],
        embed = embed,
        botName = "txAdmin Server Log",
        botAvatarUrl = "https://corepixelrp.net/assets/img/external/logs/logo-log.png"
    })
end)