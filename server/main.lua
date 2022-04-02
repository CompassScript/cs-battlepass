QBCore = nil
Citizen.CreateThread(function()
	if Config.Inventory == "QB_OLD" or Config.Inventory == "ESX" then	
		while QBCore == nil do
			TriggerEvent(Config.getSharedObject, function(obj) QBCore = obj end) 
			Citizen.Wait(0)
		end
	elseif Config.Inventory == "QB_NEW" then
		QBCore = exports[Config.CoreName]:GetCoreObject()
	end
end)

local generalData = {}

Citizen.CreateThread(function() 
	local result = exports.oxmysql:fetchSync('SELECT * FROM `battlepass`', {})
	for _, v in pairs(result) do
		local insertData = {
			player = v['player'],
			data = v['data']
		}
		table.insert(generalData, insertData)
	end
end)

RegisterNetEvent('playerLoaded_battlepass')
AddEventHandler('playerLoaded_battlepass', function()
	migrateDatabase(getlicense(source),source)
end)

function migrateDatabase(hex,source)
	local foundMigrate = 0
	dbExample = {
		isPremium = 0,
		totalBalance = 0,
		claimed = {}
	}	
	
	for _, k in pairs(generalData) do
		if k['player'] == hex then 
			foundMigrate = 1
			TriggerClientEvent('tickBattlepasstime', source, json.decode(k.data).isPremium)	
			
		end

		if next(generalData,_) == nil then
			if foundMigrate == 0 then
				exports.oxmysql:insert('INSERT INTO battlepass (player,data) VALUES (?, ?) ', {hex, json.encode(dbExample)}, function()	end)
				local insertData = {
					player = hex,
					data = json.encode(dbExample)
				}
				table.insert(generalData, insertData)
			end
		end
	end
end

function getlicense() 
	for k,v in pairs(GetPlayerIdentifiers(source))do
		if string.sub(v, 1, string.len("license:")) == "license:" then
		  return v
		end		
	end
end

RegisterNetEvent('getDBPassData')
AddEventHandler('getDBPassData', function()
	local license = getlicense(source)
	local src = source
	for _, k in pairs(generalData) do
		if k['player'] == license then 
			TriggerClientEvent('battlepassMenu', src, k.data, k.player)
		end
	end
end)

RegisterNetEvent('claimItem')
AddEventHandler('claimItem', function(itemid)
	local license = getlicense(source)
	local src = source
	for _, k in pairs(generalData) do
		if k['player'] == license then 
			local data = json.decode(k.data)
			print(json.encode(itemid))
			if table.find(data.claimed, tonumber(itemid)) then
				TriggerClientEvent('notifyUser', src, 'failed', Config.ClaimDenied)
			else
				if data.totalBalance > Config.Slots[tonumber(itemid)].point then
					local tables = data.claimed
					table.insert(tables, tonumber(itemid))
					newestdata = {
						isPremium = data.isPremium,
						totalBalance = data.totalBalance,
						claimed = tables
					}
					table.remove(generalData, _)
					local insertData = {
						player = license,
						data = json.encode(newestdata)
					}
					table.insert(generalData, insertData)
					Citizen.Wait(50)
					TriggerClientEvent('updateNUI', src, insertData.data, license)
					TriggerClientEvent('notifyUser', src, 'success', Config.ClaimSuccess)
					for _, f in pairs(Config.Slots[itemid].item) do
						if Config.Inventory == "QB_OLD" or Config.Inventory == "QB_NEW" then
							local xPlayer = QBCore.Functions.GetPlayer(src)
							xPlayer.Functions.AddItem(f, 1)
						elseif Config.Inventory == "ESX" then
							local xPlayer = QBCore.GetPlayerFromId(src)
							xPlayer.addInventoryItem(f, 1)
						end
					end
				else
					TriggerClientEvent('notifyUser', src, 'failed', Config.notEnoughLV)
				end
			end
		end
	end
end)

function table.find(t,value)
    if t and type(t)=="table" and value then
        for _, v in ipairs (t) do
            if v == value then
                return true;
            end
        end
        return false;
    end
    return false;
end

function updateDB_Q(license)
	for _, k in pairs(generalData) do
		if k['player'] == license then 
			exports.oxmysql:update('UPDATE battlepass SET data = ? WHERE player = ? ', {k.data, license}, function(affectedRows)
				if affectedRows then
				end
			end)
		end
	end
end

AddEventHandler('playerDropped', function()
	local license = getlicense(source)
	updateDB_Q(license)
end)
  

RegisterNetEvent('earnPoints')
AddEventHandler('earnPoints', function()
	local license = getlicense(source)
	local found = 0
	dbExample = {
		isPremium = 0,
		totalBalance = 0,
		claimed = {}
	}	
	for _, k in pairs(generalData) do
		if k['player'] == license then 
			found = 1
			local data = json.decode(k.data)
			newestdata = {
				isPremium = data.isPremium,
				totalBalance = data.totalBalance+Config.Points,
				claimed = data.claimed
			}
			table.remove(generalData,_)
			local insertData = {
				player = license,
				data = json.encode(newestdata)
			}
			table.insert(generalData,insertData)
		end

		if next(generalData,_) == nil then
			if found == 0 then
				exports.oxmysql:insert('INSERT INTO battlepass (player,data) VALUES (?, ?) ', {license, json.encode(dbExample)}, function()	end)
				local insertData = {
					player = license,
					data = json.encode(dbExample)
				}
				table.insert(generalData, insertData)
			end
		end
	end
end)

