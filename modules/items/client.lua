local Items = items()

local function GetItem(item)
	if item then
		item = string.lower(item)
		if item:find('weapon_') then item = string.upper(item) end
		return Items[item]
	end
	return Items
end

local function Item(name, cb)
	local item = Items[name]
	if item then
		if not item.client?.export and not item.client?.event then
			item.effect = cb
		end
	end
end

local ox_inventory = exports[ox.resource]
-----------------------------------------------------------------------------------------------
-- Clientside item use functions
-----------------------------------------------------------------------------------------------

Item('bandage', function(data, slot)
	local maxHealth = 200
	local health = GetEntityHealth(PlayerData.ped)
	-- if health < maxHealth then
		ox_inventory:useItem(data, function(data)
			if data then
				SetEntityHealth(PlayerData.ped, math.min(maxHealth, math.floor(health + maxHealth / 16)))
				ox_inventory:notify({text = 'You feel better already'})
			end
		end)
	-- end
end)

Item('armour', function(data, slot)
	if GetPedArmour(PlayerData.ped) < 100 then
		ox_inventory:useItem(data, function(data)
			if data then
				SetPlayerMaxArmour(PlayerData.id, 100)
				SetPedArmour(PlayerData.ped, 100)
			end
		end)
	end
end)

ox.parachute = false
Item('parachute', function(data, slot)
	if not ox.parachute then
		ox_inventory:useItem(data, function(data)
			if data then
				local chute = `GADGET_PARACHUTE`
				SetPlayerParachuteTintIndex(PlayerData.id, -1)
				GiveWeaponToPed(PlayerData.ped, chute, 0, true, false)
				SetPedGadget(PlayerData.ped, chute, true)
				lib.requestModel(1269906701)
				ox.parachute = CreateParachuteBagObject(PlayerData.ped, true, true)
				if slot.metadata.type then
					SetPlayerParachuteTintIndex(PlayerData.id, slot.metadata.type)
				end
			end
		end)
	end
end)

Item('phone', function(data, slot)
	exports.npwd:setPhoneVisible(not exports.npwd:isPhoneVisible())
end)

-----------------------------------------------------------------------------------------------

exports('Items', GetItem)
exports('ItemList', GetItem)
client.items = Items
