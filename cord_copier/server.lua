RegisterNetEvent('cord:checkPerms', function()
    local src = source

    if not IsPlayerAceAllowed(src, 'admin') then
        print(('Player id %s are not allowed to use this tool'):format(src))
        return
    end

    TriggerClientEvent('cord:toggle', src)
end)