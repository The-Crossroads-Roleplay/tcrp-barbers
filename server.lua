RegisterServerEvent("Telegram:GetMessages")
AddEventHandler("Telegram:GetMessages", function(src, station)
	local _source = source

	if src then
		_source = tonumber(src)
	end

	TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
		local charIdentifier = user.getSessionVar("uid")
		local recipientid = user.getSessionVar("charid")
		local recipient = user.getIdentifier()
		local firstName = user.getFirstname()
		local lastName = user.getLastname()
		MySQL.Async.fetchAll("SELECT * FROM telegrams WHERE hasRead = @hasRead AND recipientid = @recipientid AND station = @station ORDER BY id DESC", { ['@recipientid'] = charIdentifier, ['@station'] = station, ['@hasRead'] = 0}, function(result)
			TriggerClientEvent("Telegram:ReturnMessages", _source, result, firstName..' '..lastName..'#'..charIdentifier, station, false)
		end)
	end)

end)

RegisterServerEvent("Telegram:GetMessagesRestricted")
AddEventHandler("Telegram:GetMessagesRestricted", function(src, station)
	local _source = source

	if src then
		_source = tonumber(src)
	end

	TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
		local job = user.getJob()
		if job == 'police' then
			MySQL.Async.fetchAll("SELECT * FROM telegrams WHERE hasRead = @hasRead AND recipientid = @recipient AND station = @station OR hasRead = @hasRead AND station = 'regional' ORDER BY id DESC", { ['@hasRead'] = 0, ['@recipient'] = 'marshals', ['@station'] = station }, function(result)
				TriggerClientEvent("Telegram:ReturnMessages", _source, result, 'U.S. Marshals', station, true)
			end)
		end
	end)
end)

local locations = {
    ['VALENTINE']             = {restricted = false, coordinates = vector3(-178.90, 626.71, 114.09) }, -- Valentine train station
    ['RHODES']                = {restricted = false, coordinates = vector3(1225.57, -1293.87, 76.91) }, -- Rhodes train station
    ['SAINT DENIS']           = {restricted = false, coordinates = vector3(2749.55, -1399.91, 46.19) }, -- Saint Denis train station
    ['ANNESBURG']             = {restricted = false, coordinates = vector3(2939.5, 1288.56, 44.65) }, -- Annesburg Post Office
    ['BLACKWATER']            = {restricted = false, coordinates = vector3(-875.12, -1328.76, 43.96) }, -- Blackwater  Post Office
    ['STRAWBERRY']            = {restricted = false, coordinates = vector3(-1764.97, -384.16, 157.74) }, -- Strawberry  Post Office
    ['ARMADILLO']             = {restricted = false, coordinates = vector3(-3733.95, -2597.76, -12.93) }, -- Armadillo  Post Office
    ['BENEDICT POINT']        = {restricted = false, coordinates = vector3(-5227.39, -3470.52, -20.57) }, -- Benedict Point  Post Office
    ['EMERALD STATION']       = {restricted = false, coordinates = vector3(1521.99, 439.54, 90.68) }, -- Emerald Station  Post Office
    ['RIGGS STATION']         = {restricted = false, coordinates = vector3(-1094.07, -575.13, 81.89) }, -- Riggs Station  Post Office
    ['WALLACE STATION']       = {restricted = false, coordinates = vector3(-1301.11, 398.97, 94.97) }, -- Wallace Station  Post Office
    ['VALENTINE SHERIFFS OFFICE']      = {restricted = true, coordinates = vector3(-277.87, 807.51, 119.48) }, -- Valentine Sheriff's Office
    ['RHODES SHERIFFS OFFICE']         = {restricted = true, coordinates = vector3(1359.22, -1299.7, 77.76) }, -- Rhodes Sheriff's Office
    ['SAINT DENIS SHERIFFS OFFICE']    = {restricted = true, coordinates = vector3(2507.49, -1301.38, 48.95) }, -- Saint Denis Sheriff's Office
    ['ANNESBURG SHERIFFS OFFICE']      = {restricted = true, coordinates = vector3(2908.47, 1309.0, 44.94) }, -- Annesburg Sheriff's Office
    ['BLACKWATER SHERIFFS OFFICE']     = {restricted = true, coordinates = vector3(-767.63, -1266.52, 44.05) }, -- Blackwater Sheriff's Office
    ['STRAWBERRY SHERIFFS OFFICE']     = {restricted = true, coordinates = vector3(-1811.99, -354.0, 164.65) }, -- Strawberry Sheriff's Office
    ['ARMADILLO SHERIFFS OFFICE']      = {restricted = true, coordinates = vector3(-3623.35, -2602.36, -13.34) }, -- Armadillo Sheriff's Office
    ['TUMBLEWEED SHERIFFS OFFICE']     = {restricted = true, coordinates = vector3(-5531.56, -2929.12, -1.36) }, -- Tumbleweed Sheriff's Office
    ['STATE OFFICES']             = {restricted = false, coordinates = vector3(2395.47, -1083.21, 52.75) }, -- CITY HALL
	['RAVENS REST MANOR']     = {restricted = false, coordinates = vector3(2370.42, -1221.95, 47.10) }, -- Ravens Rest Manor
    ['MARSHALLS: FORT WALLACE'] = {restricted = true, coordinates = vector3(338.95, 1504.24, 181.53) }, -- Marshal's Office
}

RegisterServerEvent("Telegram:SendMessageRestricted")
AddEventHandler("Telegram:SendMessageRestricted", function(sender, station, recipient, recipientid, message, coordinates)
	MySQL.Async.insert("INSERT INTO telegrams (sender, station, recipient, recipientid, message, type, coordinates, hasRead) VALUES (@sender, @station, @recipient, @recipientid, @message, @type, @coordinates, @hasRead)",  
	{
		['@sender'] = sender, 
		['@station'] = station, 
		['@recipient'] = recipient,
		['@recipientid'] = recipientid,
		['@message'] = message,
		['@type'] = 1,
		['@coordinates'] = coordinates,
		['@hasRead'] = 0
	})
	if station == 'regional' then
		local sounds = {}
		for k, v in pairs(locations) do
			sounds[k] = exports.pmms:startByCoords(v.coordinates.x, v.coordinates.y, v.coordinates.z, {range = 25.0, url = 'https://www.youtube.com/watch?v=TeNoc4VksLQ', volume = 50, loop = false, video = false})
		end
	else
		local alertSound = exports.pmms:startByCoords(locations[station].coordinates.x, locations[station].coordinates.y, locations[station].coordinates.z, {range = 25.0, url = 'https://www.youtube.com/watch?v=TeNoc4VksLQ', volume = 50, loop = true, video = false})
		Citizen.Wait(9000)
		exports.pmms:stop(alertSound)
	end
end)

------
RegisterServerEvent("Telegram:SendMessage")
AddEventHandler("Telegram:SendMessage", function(station, identifier, message)
	local _source = source
	local sender = {}
	local identifier = tonumber(identifier)
	TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
		sender.charIdentifier = user.getSessionVar("uid")
		sender.firstName = user.getFirstname()
		sender.lastName = user.getLastname()
		if identifier == 0 then
			TriggerEvent('Telegram:SendMessageRestricted', sender.firstName..' '..sender.lastName..'#'..sender.charIdentifier, station, 'U.S. Marshals', 'marshals', message)
			TriggerClientEvent("redemrp_notification:start", _source, "Your emergency telegram has been posted!", 5)
			return
		end
		
		TriggerEvent('redem:getPlayers', function(characters)
			for k, v in pairs(characters) do
				if identifier == v.getSessionVar("uid") then
					local recipientid = v.getSessionVar("uid")
					TriggerEvent('redemrp:getPlayerFromId', k, function(user2)
						local recipient = user2.getFirstname()..' '..user2.getLastname()..'#'..recipientid
						MySQL.Async.insert("INSERT INTO telegrams (sender, station, recipient, recipientid, message, type, hasRead) VALUES (@sender, @station, @recipient, @recipientid, @message, @type, @hasRead)",  
						{
							['@sender'] = sender.firstName..' '..sender.lastName..'#'..sender.charIdentifier, 
							['@station'] = station, 
							['@recipient'] = recipient, 
							['@recipientid'] = identifier, 
							['@message'] = message,
							['@type'] = 1,
							['@hasRead'] = 0,
						})
						TriggerClientEvent("redemrp_notification:start", _source, "Your telegram has been posted!", 5)
						return
					end)
					return
				end
			end

			MySQL.Async.fetchAll("SELECT * FROM characters WHERE id = @identifier LIMIT 1", { ['@identifier'] = tonumber(identifier)}, function(result)
				if result[1] then 
					local recipient = result[1].identifier 
					local recipientid = result[1].id
					MySQL.Async.fetchAll("INSERT INTO telegrams (sender, station, recipient, recipientid, message, type, hasRead) VALUES (@sender, @station, @recipient, @recipientid, @message, @type, @hasRead)",  
					{
						['@sender'] = sender.firstName..' '..sender.lastName..'#'..sender.charIdentifier,
						['@station'] = station, 
						['@recipient'] = result[1].firstname..' '..result[1].lastname..'#'..result[1].id, 
						['@recipientid'] = identifier, 
						['@message'] = message,
						['@type'] = 1,
						['@hasRead'] = 0,
					})
					TriggerClientEvent("redemrp_notification:start", _source, "Your telegram has been posted!", 5)
					return
				end
				TriggerClientEvent("redemrp_notification:start", _source, "The recipient does not exist.", 5)
			end)
		end)
	end)
end)
-------



RegisterServerEvent("Telegram:DeleteMessage")
AddEventHandler("Telegram:DeleteMessage", function(id, station, restricted)
	local _source = source
	local insert = nil
	
	MySQL.Async.execute("UPDATE telegrams SET hasRead = @hasRead WHERE id=@id",  { ['@id'] = id, ['@hasRead'] = 1}, function(insertId)
		insert = insertId
	end)

	while insert == nil do
		Citizen.Wait(100)
	end

	if restricted == true then
		TriggerEvent("Telegram:GetMessagesRestricted", _source, station)
	else
		TriggerEvent("Telegram:GetMessages", _source, station)
	end
end)

function pairsByKeys(t, f)
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
	table.sort(a, f)
	local i = 0
	local iter = function()
	  i = i + 1
	  if a[i] == nil then return nil
	  else return a[i], t[a[i]]
	  end
	end
	return iter
end