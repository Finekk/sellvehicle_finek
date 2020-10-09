ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand('sprzedajpojazd', function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	if tonumber(args[1]) and args[2] then
		local tPlayer = ESX.GetPlayerFromId(args[1])
		if tPlayer then
			local plate = args[2]
			local result = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @identifier AND plate = @plate', {
				['@identifier'] = xPlayer.identifier,
				['@plate'] = plate
			}) 
			if result[1] ~= nil then
				MySQL.Async.execute('UPDATE owned_vehicles SET owner = @target WHERE owner = @owner AND plate = @plate', {
				['@owner'] = xPlayer.identifier,
				['@plate'] = plate,
				['@target'] = tPlayer.identifier
				}, function (rowsChanged)
					if rowsChanged ~= 0 then
						tPlayer.showNotification("~g~Kupiles pojazd o rejestracji ~w~"..plate.." od "..xPlayer.name)
						tPlayer.showNotification("~g~Sprzedales pojazd o rejestracji ~w~"..plate.." dla "..tPlayer.name)
					end
				end)
			else
				xPlayer.showNotification("~r~Podana rejestracja nie jest prawidłowa")
			end
		else
			xPlayer.showNotification("~r~Nie można znalezć gracza o danym ID")
		end
	else
		xPlayer.showNotification("~r~Złe użycie. /sprzedajpojazd ID Plate")
	end
end, false)