require "BicycleAttachments"

local originalGrabValid = ISGrabItemAction.isValid

function ISGrabItemAction:isValid()
    local item = self.item:getItem():getType()
    if item == ContainerMap[item] then
		return false;
	end
    if item == "Bicycle" then
        return false;
    end
    return originalGrabValid(self)
end

local originalIsUnequipValid = ISUnequipAction.isValid

function ISUnequipAction:isValid()
    if self.item
    and type(self.item.getType) == "function"
    and self.item:getType() == "Bicycle" or self.item:getType() == ContainerMap[self.item:getType()] then
        return false
    end
    return originalIsUnequipValid(self)
end

local originalIsEquipValid = ISEquipWeaponAction.isValid

function ISEquipWeaponAction:isValid()
    local primaryItem = self.character:getPrimaryHandItem()
    if primaryItem and primaryItem:getType() == "Bicycle" then self.character:Say("I should hop off first") return false end
    if self.item
    and type(self.item.getType) == "function"
    and self.item:getType() == ContainerMap[self.item:getType()] then
        return false
    end
    return originalIsEquipValid(self)
end

local originalWearClothing = ISWearClothing.isValid

function ISWearClothing:isValid()
    local item = self.item:getType()
    if item == ContainerMap[item] then
        return true;
    end
    return originalWearClothing(self)
end

local originalGetWearClothesDuration = ISWearClothing.getDuration

function ISWearClothing:getDuration()
    local item = self.item:getType()
    if item == "Bicycle" or item == ContainerMap[item] then
        return 0
    end
    return originalGetWearClothesDuration(self)
end

local originalDropItem = ISInventoryPaneContextMenu.onDropItems

function ISInventoryPaneContextMenu.onDropItems(items, player)
    items = ISInventoryPane.getActualItems(items)
	for _,item in ipairs(items) do
        if item:getType() == "Bicycle" then
            local pzPlayer = getSpecificPlayer(player)
            pzPlayer:setBlockMovement(true)
            pzPlayer:setVariable("droppingBicycle", "true")
            Events.OnPlayerUpdate.Remove(UpdateBicycleFlag)
            Events.OnPlayerUpdate.Remove(UpdateBicycleAudio)
            local emitter = pzPlayer:getEmitter()
            emitter:stopSoundByName('Bicycle_Riding')
            BicycleAttachments.dropContainers()
            BikeMsTimer(400, function()
                pzPlayer:setBlockMovement(false)
                pzPlayer:setVariable("BicycleActive", "false")
                pzPlayer:setCanShout(true);
                pzPlayer:setBannedAttacking(false)
                pzPlayer:setVariable("droppingBicycle", "false")
                pzPlayer:setIgnoreAutoVault(false)
            end)
        end
	end
    return originalDropItem(items, player)
end

local originalCreate

local function onGameStart()

    originalCreate = ISPlace3DItemCursor.create

    function ISPlace3DItemCursor:create()
        local item = self.items and self.items[1]
        if item and item:getType() == "Bicycle" then
            local player = getSpecificPlayer(0)
            player:removeFromHands(item)
            Events.OnPlayerUpdate.Remove(UpdateBicycleFlag)
            Events.OnPlayerUpdate.Remove(UpdateBicycleAudio)
            local emitter = player:getEmitter()
            emitter:stopSoundByName('Bicycle_Riding')
            player:setVariable("Bicycle_Riding", "false")
            player:setVariable("BicycleActive", "false")
            player:setCanShout(true);
            player:setBannedAttacking(false)
            player:setIgnoreAutoVault(false)

            BikeMsTimer(200, function()
                local plrQueue = ISTimedActionQueue.getTimedActionQueue(player)
                if not plrQueue or not plrQueue.queue then return end

                for _, action in ipairs(plrQueue.queue) do
                    if plrQueue.queue[1].Type == "ISDropWorldItemAction" then
                        BicycleAttachments.dropContainers()
                        break
                    end
                    if action.Type == "ISWalkToTimedAction" then
                        action:setOnComplete(BicycleAttachments.dropContainers)
                        break
                    end
                end
            end)
        end

        return originalCreate(self)
    end
end

Events.OnGameStart.Add(onGameStart)