require "TimedActions/ISBaseTimedAction"
require "Bicycle/BicycleMenu"

BicycleHopOnAction = ISBaseTimedAction:derive("BicycleHopOnAction")
local bicycleHopOnInstance = nil

function BicycleHopOnAction.isValid(args)
	for i,v in ipairs(BicycleMenu.typesTable) do
		if args["character"]:getInventory():contains(tostring(v)) then
			return false
		end
	end
	return true
end

function BicycleHopOnAction:waitToStart()
	return false
end

function BicycleHopOnAction:update()

end

function BicycleHopOnAction.squareHasObject(square)
    local objects = square:getObjects()
    for i = 0, objects:size()-1 do
        local obj = objects:get(i)
        if obj and obj.isHoppable then
            local hoppable = obj:isHoppable()
            if hoppable then
                return true, obj
            end
        end
    end
    return false, nil
end

function BicycleHopOnAction.squareIsRough(square)
    local roughMaterials = {
        Sand = true,
        Grass = true,
        Gravel = true,
        Dirt = true
    }
    local function isRoughMaterial(mat)
        return roughMaterials[mat] or false
    end
    local objects = square:getObjects()
    for i = 0, objects:size()-1 do
        local obj = objects:get(i)
        local mat = obj:getProperties():Val("FootstepMaterial")
        if obj and mat and isRoughMaterial(mat) then
            return true
        end
    end
    return false, nil
end

function BicycleHopOnAction.nearbySquareHasObject(square)
    local squares = {
        square,
        square:getN(),
        square:getS(),
        square:getE(),
        square:getW(),
    }
    for _, s in ipairs(squares) do
        if s then
            local found, obj = BicycleHopOnAction.squareHasObject(s)
            if found then
                return true, obj
            end
        end
    end
    return false, nil
end

function UpdateBicycleAudio(player)
    local bicycleActive = player:getVariableBoolean("BicycleActive")
    local emitter = player:getEmitter()
    local soundVolume = PZAPI.ModOptions:getOptions("BicycleMod"):getOption("BicycleSoundVolume"):getValue()

    if not bicycleActive then
        if emitter:isPlaying('Bicycle_Riding') then
            emitter:stopSoundByName('Bicycle_Riding')
        end
        player:setVariable("Bicycle_Riding", "false")
        player:setVariable("Bicycle_RollingTimestamp", "0")
        return
    end

    if not player:getVariableBoolean("Bicycle_Riding") then
        player:setVariable("Bicycle_RollingTimestamp", "0")
        return
    end

    if emitter:isPlaying('Bicycle_Riding') and player:isPlayerMoving() then
        addSound(nil, player:getX(), player:getY(), player:getZ(), 4, 4)
        BicycleMenu.rotateWheels()
        return
    elseif not player:isPlayerMoving() then
        emitter:stopSoundByName('Bicycle_Riding')
        return
    end

    if tonumber(player:getVariableString("Bicycle_RollingTimestamp")) < 1 then
        local ts = getTimestampMs()
        player:setVariable("Bicycle_RollingTimestamp", tostring(ts))
    end

    local startTs = tonumber(player:getVariableString("Bicycle_RollingTimestamp"))
    local currentTs = getTimestampMs()

    if currentTs - startTs >= 250 and not emitter:isPlaying('Bicycle_Riding') then
        local sound = emitter:playSound('Bicycle_Riding')
        emitter:setVolume(sound, soundVolume)
        BicycleMenu.rotateWheels()
        addSound(nil, player:getX(), player:getY(), player:getZ(), 4, 4)
        player:setVariable("Bicycle_RollingTimestamp", "0")
    end
end


function UpdateBicycleFlag(player)
    local primaryItem = player:getPrimaryHandItem()
    local inventory = player:getInventory()

    if not primaryItem then
        return
    end

    if primaryItem and primaryItem:getType() == "Bicycle" then
        local damagedParts = ISHealthPanel.instance:getDamagedParts()
        player:setVariable("BicycleActive", "true")
        player:setIgnoreAutoVault(true)
        local totalContainerWeight = 0
        for j = 1, inventory:getItems():size() do
            local item = inventory:getItems():get(j - 1)
            local typeName = item:getType()
            if ContainerMap[typeName] then
                totalContainerWeight = totalContainerWeight + item:getInventoryWeight()
            end
        end

        local weightModifier = 1
        if totalContainerWeight > 0 then
            weightModifier = math.max(0.65, 1 - 0.35 * (totalContainerWeight / 20))
        end
        local damageModifier = 1
        for _, part in ipairs(damagedParts) do
            local t = string.lower(tostring(part:getType()))
            if t:find("leg") or t:find("foot") then
                if part:HasInjury() and part:getFractureTime()>0 then
                damageModifier = 0.01
                break
                elseif part:getHealth()<75 then
                damageModifier = (part:getHealth()/100)*0.8
                break
                end
            end
        end
        local options = PZAPI.ModOptions:getOptions("BicycleMod")
        local bicycleImmersive = options:getOption("BicycleImmersive"):getValue()
        local sq = player:getSquare()
        local isRough = BicycleHopOnAction.squareIsRough(sq)
        if isRough and bicycleImmersive then
            weightModifier = weightModifier * 0.75
        end
        local finalSpeed = damageModifier * weightModifier
        player:setVariable("BicycleSpeed", finalSpeed)
        return
    end
end


function BicycleHopOnAction:start()
	self.character:setVariable("BicycleActive", "true")
	UpdateBicycleFlag(self.character)
end

function BicycleHopOnAction:stop()

end

function BicycleHopOnAction:perform()
    local inventoryItem = self.item:getItem()
    -- if self.item:getSquare() then
    --     self.item:getSquare():transmitRemoveItemFromSquare(self.item)
    -- end
    -- self.item:removeFromWorld()
    -- self.item:removeFromSquare()
    -- self.item:setSquare(nil)
    -- inventoryItem:setWorldItem(nil)
    -- inventoryItem:setJobDelta(0.0)
    -- self.inventory:setDrawDirty(true)
    -- self.inventory:AddItem(inventoryItem)
    self.character:setIgnoreAutoVault(true)
    BicycleHopOnAction.equipWeapon(inventoryItem, false, true, self.character:getPlayerNum())
    -- if self.saddlebag then
    --     ISTransferAction:transferItem(self.character, self.saddlebag, ISInventoryPage.floorContainer[self.character:getPlayerNum() + 1], self.inventory, self.character:getSquare());
    --     self.character:setWornItem("Bicycle_Saddlebag", self.saddlebag);
    --         BikeMsTimer(300, function()
    --             self.character:setBlockMovement(false)
    --         end)
    -- end
    -- if self.basket then
    --     ISTransferAction:transferItem(self.character, self.basket, ISInventoryPage.floorContainer[self.character:getPlayerNum() + 1], self.inventory, self.character:getSquare());
    --     self.character:setWornItem("Bicycle_Basket", self.basket);
    --         BikeMsTimer(300, function()
    --             self.character:setBlockMovement(false)
    --         end)
    -- end
    -- if self.crate then
    --     ISTransferAction:transferItem(self.character, self.crate, ISInventoryPage.floorContainer[self.character:getPlayerNum() + 1], self.inventory, self.character:getSquare());
    --     self.character:setWornItem("Bicycle_Crate", self.crate);
    --         BikeMsTimer(300, function()
    --             self.character:setBlockMovement(false)
    --         end)
    -- end
    if not self.saddlebag and not self.basket and not self.crate then
        self.character:setBlockMovement(false)
    end

    ISBaseTimedAction.perform(self)
end

BicycleHopOnAction.onCompleteEquip = function(playerObj, weapon)
    playerObj:setPrimaryHandItem(weapon);
    playerObj:setSecondaryHandItem(weapon);
    BicycleAttachments.pickupContainers()
    playerObj:setVariable("BicycleActive", "true")
    playerObj:setCanShout(false);
    playerObj:setBannedAttacking(true)
    playerObj:setIgnoreAutoVault(true)
    Events.OnPlayerUpdate.Add(UpdateBicycleFlag)
    Events.OnPlayerUpdate.Add(UpdateBicycleAudio)
end

BicycleHopOnAction.equipWeapon = function(weapon, primary, twoHands, player)
	local playerObj = getSpecificPlayer(0)
    local inv = playerObj:getInventory()
	if isForceDropHeavyItem(playerObj:getPrimaryHandItem()) then
        playerObj:removeFromHands(playerObj:getPrimaryHandItem());
	end
    local action = ISInventoryTransferAction:new(playerObj, weapon, ISInventoryPage.floorContainer[1], inv, 0)
    action:setOnComplete(BicycleHopOnAction.onCompleteEquip, playerObj, weapon)
    ISTimedActionQueue.add(action)
end

SaddleBags = {}

CustomKeyPressed = function(key)
    local V_KEY = Keyboard.KEY_V
    if key == V_KEY then
		SaddleBags = {};
	end
end

-- local function handleBicycleContainer(player)
--     local playerSq = player:getSquare()
--     local items = BicycleMenu.getItems(playerSq)
--     local pdata = getPlayerData(0)
--     for i, worldObj in ipairs(items) do
--         if instanceof(worldObj, "IsoWorldInventoryObject") then
--             local item = worldObj:getItem()
--             if item:getType() == "Saddlebag" then
--                 table.insert(SaddleBags, item:getWorldItem())
--             end
--         end
--     end
--     if #SaddleBags > 0 then
--         for i, item in ipairs(SaddleBags) do
--             item:setSquare(playerSq)
--         end
--     end
-- end



function BicycleHopOnAction:new( item, player, saddlebag, basket, crate)

	local o = {}
	setmetatable( o, self)
	self.__index = self
	o.maxTime = 0
	o.character = player
	o.inventory = player:getInventory()
	o.item = item
    o.saddlebag = nil
    o.basket = nil
    o.crate = nil
	o.stopOnWalk = false
	o.stopOnRun = false
    o.stopOnAim = false
    o.options = PZAPI.ModOptions:getOptions("BicycleMod")
    o.speedMultSlow = o.options:getOption("SpeedMultSlow"):getValue()
    o.speedMultFast = o.options:getOption("SpeedMultFast"):getValue()

	o.character:setVariable("BicycleActive", "true")
    o.character:setVariable("BicycleWalkSpeed", o.speedMultSlow)
    o.character:setVariable("BicycleRunSpeed", o.speedMultFast)

    if saddlebag then
        o.saddlebag = saddlebag:getItem()
    end
    if basket then
        o.basket = basket:getItem()
    end
    if crate then
        o.crate = crate:getItem()
    end

    bicycleHopOnInstance = o
	return o
end

Events.OnKeyPressed.Add(CustomKeyPressed)