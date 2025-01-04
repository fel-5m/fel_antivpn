local function extractIP(source)
    local endpoint = GetPlayerEndpoint(source)
    if endpoint then
        local ip = endpoint:match("([^:]+)")
        return ip
    end
    return nil
end

local function checkIP(ip, deferrals)
    deferrals.defer()
    Wait(0)  
    deferrals.update("Vérification de vos informations...")

    local checkUrl = "https://blackbox.ipinfo.app/lookup/" .. ip

    PerformHttpRequest(checkUrl, function(statusCode, response, headers)
        if statusCode == 200 then
            if response == "N" then
                deferrals.done() 
            else
                deferrals.done("Votre connexion a été refusée car vous utilisez un VPN ou un proxy.")
            end
        else
            deferrals.done("Nous ne pouvons pas vérifier votre adresse IP actuellement. Réessayez plus tard.")
        end
    end, "GET")
end

AddEventHandler("playerConnecting", function(playerName, setKickReason, deferrals)
    local playerIP = extractIP(source)
    print(playerIP)
    if playerIP then
        checkIP(playerIP, deferrals)
    else
        deferrals.done("Impossible de récupérer votre adresse IP.")
    end
end)