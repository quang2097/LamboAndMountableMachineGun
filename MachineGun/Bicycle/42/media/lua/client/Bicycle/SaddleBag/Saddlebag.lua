
-- local function calcBaseForExtraWithBaseInt(baseCapacity, extraCapacity)
--     local a     = 0.005
--     local bCoef = 1.45
--     local target = baseCapacity + extraCapacity
--     local disc   = bCoef*bCoef + 4*a*target
--     -- solve a*x^2 + b*x = target
--     local root   = (-bCoef + math.sqrt(disc)) / (2*a)
--     return math.ceil(root)     -- guarantees at least target after ceil( f(x) )
-- end

-- local function calcBaseForExtraInt()
--     return math.ceil(calcBaseForExtraWithBaseInt(20, 6))
-- end

-- BicycleContainerWeightApplied = nil

-- local function invertDeltaArg(extraKg, currentBase)
--     local a, b = 0.005, 1.45
--     local B = b + 2*a*currentBase
--     local disc = B*B + 4*a*extraKg
--     local root = (-B + math.sqrt(disc)) / (2*a)
--     return math.floor(root)
-- end

-- local function applyUpgrade(player, extraKg)
--     local currentBW  = player:getMaxWeightBase()
--     local deltaArg   = invertDeltaArg(extraKg, currentBW)
--     player:setMaxWeightBase(currentBW + deltaArg)
-- end

BicycleAttachments = {}

function BicycleAttachments.dropContainers()
    local player = getSpecificPlayer(0)
    local inventory = player:getInventory()
    Events.OnPlayerUpdate.Remove(UpdateBicycleFlag)
    Events.OnPlayerUpdate.Remove(UpdateBicycleAudio)
    local equippedBag = FindEquippedItem(player, "Saddlebag")
    local equippedBasket = FindEquippedItem(player, "Basket")
    local equippedCrate = FindEquippedItem(player, "Crate")
    if equippedBag then
        player:setWornItem("Bicycle_Saddlebag", nil);
        local action = ISInventoryTransferAction:new(player, equippedBag, inventory, ISInventoryPage.floorContainer[1], 14);
        ISTimedActionQueue.add(action);
    end
    if equippedBasket then
        player:setWornItem("Bicycle_Basket", nil);
        local action = ISInventoryTransferAction:new(player, equippedBasket, inventory, ISInventoryPage.floorContainer[1], 14);
        ISTimedActionQueue.add(action);
    end
    if equippedCrate then
        player:setWornItem("Bicycle_Crate", nil);
        local action = ISInventoryTransferAction:new(player, equippedCrate, inventory, ISInventoryPage.floorContainer[1], 14);
        ISTimedActionQueue.add(action);
    end
    local inventoryBag, srcSaddleBag = FindInventoryItem(player, "Saddlebag")
    local inventoryBasket, srcBasketBag = FindInventoryItem(player, "Basket")
    local inventoryCrate, srcCrateBag = FindInventoryItem(player, "Crate")
    if inventoryBag and srcSaddleBag then
        local action = ISInventoryTransferAction:new(player, inventoryBag, srcSaddleBag:getItemContainer(), ISInventoryPage.floorContainer[1], 14);
        ISTimedActionQueue.add(action);
    end
    if inventoryBasket and srcBasketBag then
        local action = ISInventoryTransferAction:new(player, inventoryBasket, srcBasketBag:getItemContainer(), ISInventoryPage.floorContainer[1], 14);
        ISTimedActionQueue.add(action);
    end
    if inventoryCrate and srcCrateBag then
        local action = ISInventoryTransferAction:new(player, inventoryCrate, srcCrateBag:getItemContainer(), ISInventoryPage.floorContainer[1], 14);
        ISTimedActionQueue.add(action);
    end
    local pdata = getPlayerData(0)
    if pdata and pdata.playerInventory then
        pdata.playerInventory:refreshBackpacks()
        pdata.lootInventory:refreshBackpacks()
    end
end

function BicycleAttachments.pickupContainers()
    local player = getSpecificPlayer(0)
    local inventory = player:getInventory()
    local floorBag = FindFloorItem(player, "Saddlebag")
    local floorBasket = FindFloorItem(player, "Basket")
    local floorCrate = FindFloorItem(player, "Crate")
    local function wearItem(playerObj, location, item)
        playerObj:setWornItem(location, item);
    end
    if floorBag then
        local action = ISInventoryTransferAction:new(player, floorBag:getItem(), ISInventoryPage.floorContainer[1], inventory, 14)
        action:setOnComplete(wearItem, player, "Bicycle_Saddlebag", floorBag:getItem());
        ISTimedActionQueue.add(action);
    end
    if floorBasket then
        local action = ISInventoryTransferAction:new(player, floorBasket:getItem(), ISInventoryPage.floorContainer[1], inventory, 14)
        action:setOnComplete(wearItem, player, "Bicycle_Basket", floorBasket:getItem());
        ISTimedActionQueue.add(action);
    end
    if floorCrate then
        local action = ISInventoryTransferAction:new(player, floorCrate:getItem(), ISInventoryPage.floorContainer[1], inventory, 14)
        action:setOnComplete(wearItem, player, "Bicycle_Crate", floorCrate:getItem());
        ISTimedActionQueue.add(action);
    end
    local pdata = getPlayerData(0)
    if pdata and pdata.playerInventory then
        pdata.playerInventory:refreshBackpacks()
        pdata.lootInventory:refreshBackpacks()
    end
end

function BicycleAttachments.transferContainersToTrunk(dest)
    local player = getSpecificPlayer(0)
    local inventory = player:getInventory()
    local equippedBag = FindEquippedItem(player, "Saddlebag")
    local equippedBasket = FindEquippedItem(player, "Basket")
    local equippedCrate = FindEquippedItem(player, "Crate")
    local floorBag = FindFloorItem(player, "Saddlebag")
    local floorBasket = FindFloorItem(player, "Basket")
    local floorCrate = FindFloorItem(player, "Crate")
    if equippedBag then
        player:setWornItem("Bicycle_Saddlebag", nil);
        ISTimedActionQueue.add(ISInventoryTransferAction:new(player, equippedBag, inventory, dest, 14));
    end
    if equippedBasket then
        player:setWornItem("Bicycle_Basket", nil);
        ISTimedActionQueue.add(ISInventoryTransferAction:new(player, equippedBasket, inventory, dest, 14));
    end
    if equippedCrate then
        player:setWornItem("Bicycle_Crate", nil);
        ISTimedActionQueue.add(ISInventoryTransferAction:new(player, equippedCrate, inventory, dest, 14));
    end
    if floorBag then
        ISTimedActionQueue.add(ISInventoryTransferAction:new(player, floorBag:getItem(), ISInventoryPage.floorContainer[1], dest, 14));
    end
    if floorBasket then
        ISTimedActionQueue.add(ISInventoryTransferAction:new(player, floorBasket:getItem(), ISInventoryPage.floorContainer[1], dest, 14));
    end
    if floorCrate then
        ISTimedActionQueue.add(ISInventoryTransferAction:new(player, floorCrate:getItem(), ISInventoryPage.floorContainer[1], dest, 14));
    end
    Events.OnPlayerUpdate.Remove(UpdateBicycleFlag)
    Events.OnPlayerUpdate.Remove(UpdateBicycleAudio)
    local emitter = player:getEmitter()
    emitter:stopSoundByName('Bicycle_Riding')
    player:setVariable("Bicycle_Riding", "false")
    player:setVariable("BicycleActive", "false")
    player:setCanShout(true);
    player:setBannedAttacking(false)
    player:setIgnoreAutoVault(false)
    local pdata = getPlayerData(0)
    if pdata and pdata.playerInventory then
        pdata.playerInventory:refreshBackpacks()
        pdata.lootInventory:refreshBackpacks()
    end
end

function BicycleAttachments.transferContainersToInventory(src, dest)
    local player = getSpecificPlayer(0)
    local trunkBag = nil
    local trunkBasket = nil
    local trunkCrate = nil
    for j=1,src:getItems():size() do
        local item = src:getItems():get(j-1)
        local type = item:getType()
        if type == "Saddlebag" then
            trunkBag = item
        elseif type == "Basket" then
            trunkBasket = item
        elseif type == "Crate" then
            trunkCrate = item
        end
    end
    if trunkBag then
        ISTimedActionQueue.add(ISInventoryTransferAction:new(player, trunkBag, src, dest, 14));
    end
    if trunkBasket then
        ISTimedActionQueue.add(ISInventoryTransferAction:new(player, trunkBasket, src, dest, 14));
    end
    if trunkCrate then
        ISTimedActionQueue.add(ISInventoryTransferAction:new(player, trunkCrate, src, dest, 14));
    end
    local floorBag = FindFloorItem(player, "Saddlebag")
    local floorBasket = FindFloorItem(player, "Basket")
    local floorCrate = FindFloorItem(player, "Crate")
    if floorBag then
        ISTimedActionQueue.add(ISInventoryTransferAction:new(player, floorBag:getItem(), ISInventoryPage.floorContainer[1], dest, 14));
    end
    if floorBasket then
        ISTimedActionQueue.add(ISInventoryTransferAction:new(player, floorBasket:getItem(), ISInventoryPage.floorContainer[1], dest, 14));
    end
    if floorCrate then
        ISTimedActionQueue.add(ISInventoryTransferAction:new(player, floorCrate:getItem(), ISInventoryPage.floorContainer[1], dest, 14));
    end
    sendEquip(player)
    triggerEvent("OnClothingUpdated", player)
    local pdata = getPlayerData(0)
    if pdata and pdata.playerInventory then
        pdata.playerInventory:refreshBackpacks()
        pdata.lootInventory:refreshBackpacks()
    end
end

function BicycleAttachments.transferContainersFromTrunk(srcCont)
    local player = getSpecificPlayer(0)
    local trunkBag = nil
    local trunkBasket = nil
    local trunkCrate = nil
    for j=1,srcCont:getItems():size() do
        local item = srcCont:getItems():get(j-1)
        local type = item:getType()
        if type == "Saddlebag" then
            trunkBag = item
        elseif type == "Basket" then
            trunkBasket = item
        elseif type == "Crate" then
            trunkCrate = item
        end
    end
    if trunkBag then
        ISTimedActionQueue.add(ISInventoryTransferAction:new(player, trunkBag, srcCont, ISInventoryPage.floorContainer[1], 14));
    end
    if trunkBasket then
        ISTimedActionQueue.add(ISInventoryTransferAction:new(player, trunkBasket, srcCont, ISInventoryPage.floorContainer[1], 14));
    end
    if trunkCrate then
        ISTimedActionQueue.add(ISInventoryTransferAction:new(player, trunkCrate, srcCont, ISInventoryPage.floorContainer[1], 14));
    end
    sendEquip(player)
    triggerEvent("OnClothingUpdated", player)
    local pdata = getPlayerData(0)
    if pdata and pdata.playerInventory then
        pdata.playerInventory:refreshBackpacks()
        pdata.lootInventory:refreshBackpacks()
    end
end

local transferContainer = false

local originalNewTransferAction = ISInventoryTransferAction.new

function ISInventoryTransferAction:new (character, item, srcContainer, destContainer, time)
    local newTime = time
    if item and item.getItemContainer then
        if item:getItemContainer():getType() == ContainerMap[item:getItemContainer():getType()] and time == 14 then
            self.maxTime = 0
            self.allowTransfer = true
            newTime = 0
        else
            self.allowTransfer = false
        end
    end
    return originalNewTransferAction(self, character, item, srcContainer, destContainer, newTime)
end


local originalIsValid = ISInventoryTransferAction.isValid

function ISInventoryTransferAction:isValid()
    if not self.destContainer or not self.destContainer.getType then
        return false
    end
    local destCont = self.destContainer:getType()
    if destCont == "Basket" or destCont == "Saddlebag" or destCont == "Crate" then
        if self.item:getType() == "Bicycle" then
            return false
        end
        if self.item:getType() == ContainerMap[self.item:getType()] then
            return false
        end
        local container = self.destContainer
        local contW = container:getEffectiveCapacity(self.character)
        local contentsW = container:getContentsWeight()
        local itemW = self.item:getWeight()
        if itemW + contentsW > contW then
            return false
        end
        return true
    end
    if self.item:getType() == ContainerMap[self.item:getType()] and self.allowTransfer == false then
		return false;
	end
    if self.item:getType() == ContainerMap[self.item:getType()] and self.allowTransfer == true then
		return true;
	end

    if self.item:getType() == "Bicycle" then
        local allowTransferInv = PZAPI.ModOptions:getOptions("BicycleMod"):getOption("BicycleTransferInv"):getValue()
        local inventory = self.character:getInventory():getType()
        if destCont == "floor" or destCont == "TruckBed" or destCont == "TruckBedOpen" or destCont == "TrailerTrunk" or destCont:find("Trunk") or allowTransferInv then
            if destCont == "floor" and self.maxTime == 0 then
                local plrQueue = ISTimedActionQueue.getTimedActionQueue(self.character);
                local action = plrQueue.queue[1]
                action:setOnComplete(BicycleMenu.onCompleteDrop, self.character, self.item)
                return true
            end
            local floorBag = FindFloorItem(self.character, "Saddlebag")
            local floorBasket = FindFloorItem(self.character, "Basket")
            local floorCrate = FindFloorItem(self.character, "Crate")

            local equippedBag = FindEquippedItem(self.character, "Saddlebag")
            local equippedBasket = FindEquippedItem(self.character, "Basket")
            local equippedCrate = FindEquippedItem(self.character, "Crate")

            local bagsWeight = 0

            if destCont == "TruckBed" or destCont == "TruckBedOpen" or destCont == "TrailerTrunk" or destCont:find("Trunk") then
                local trunkCapacity = self.destContainer:getCapacity()
                local trunkItemsWeight = self.destContainer:getContentsWeight()
                if floorBag then
                    bagsWeight = bagsWeight + floorBag:getItem():getContentsWeight()
                end
                if floorBasket then
                    bagsWeight = bagsWeight + floorBasket:getItem():getContentsWeight()
                end
                if floorCrate then
                    bagsWeight = bagsWeight + floorCrate:getItem():getContentsWeight()
                end
                if equippedBag then
                    bagsWeight = bagsWeight + equippedBag:getContentsWeight()
                end
                if equippedBasket then
                    bagsWeight = bagsWeight + equippedBasket:getContentsWeight()
                end
                if equippedCrate then
                    bagsWeight = bagsWeight + equippedCrate:getContentsWeight()
                end
                if bagsWeight + trunkItemsWeight > trunkCapacity then
                    self.character:Say("My bike is too heavy")

                    return false
                end
                local plrQueue = ISTimedActionQueue.getTimedActionQueue(self.character);
                local action = plrQueue.queue[1]
                action:setOnComplete(BicycleAttachments.transferContainersToTrunk, self.destContainer)

                return true
            end

            local srcCont = self.srcContainer
            if srcCont:getType() == "TruckBed" or srcCont:getType() == "TruckBedOpen" or srcCont:getType() == "TrailerTrunk" or srcCont:getType():find("Trunk") then
                if allowTransferInv and destCont == inventory then
                    local plrQueue = ISTimedActionQueue.getTimedActionQueue(self.character);
                    local action = plrQueue.queue[1]
                    action:setOnComplete(BicycleAttachments.transferContainersToInventory, self.srcContainer, self.destContainer)

                    return true
                end
                local plrQueue = ISTimedActionQueue.getTimedActionQueue(self.character);
                local action = plrQueue.queue[1]
                action:setOnComplete(BicycleAttachments.transferContainersFromTrunk, srcCont)

                return true
            end
            if destCont == "floor" then
                local plrQueue = ISTimedActionQueue.getTimedActionQueue(self.character);
                local action = plrQueue.queue[1]
                action:setOnComplete(BicycleAttachments.dropContainers)

                return true
            end
            if allowTransferInv and destCont == inventory and self.maxTime > 0 then
                local plrQueue = ISTimedActionQueue.getTimedActionQueue(self.character);
                local action = plrQueue.queue[1]
                action:setOnComplete(BicycleAttachments.transferContainersToInventory, self.srcContainer, self.destContainer)

                return true
            end
            if destCont == inventory and self.maxTime == 0 then
                local plrQueue = ISTimedActionQueue.getTimedActionQueue(self.character);
                local action = plrQueue.queue[1]
                action:setOnComplete(BicycleHopOnAction.onCompleteEquip, self.character, self.item)

                return true
            end
            if allowTransferInv then
                local plrQueue = ISTimedActionQueue.getTimedActionQueue(self.character);
                local action = plrQueue.queue[1]
                action:setOnComplete(BicycleAttachments.transferContainersToInventory, self.srcContainer, self.character:getInventory())
            end

            return true;
        end

        if destCont == inventory and self.maxTime == 0 and self.item:getType() == "Bicycle" then
            local plrQueue = ISTimedActionQueue.getTimedActionQueue(self.character);
                local action = plrQueue.queue[1]
                action:setOnComplete(BicycleHopOnAction.onCompleteEquip, self.character, self.item)

            return true
        end

        return false;
    end
    return originalIsValid(self)
end

function FindBicycle(player)
    local square = player:getSquare()
    local items = BicycleMenu.getItems(square)
    local closestBicycle = nil
    local closestBicycleDistance = 1000

    for i = 1, #items do
        local worldObj = items[i]
        if instanceof(worldObj, "IsoWorldInventoryObject") then
            local item = worldObj:getItem()
            if item:getType() == "Bicycle" then
                local dist = BicycleMenu.getDistance2D(worldObj:getWorldPosX(), worldObj:getWorldPosY(), square:getX(), square:getY())
                if dist < closestBicycleDistance then
                    closestBicycle = worldObj
                    closestBicycleDistance = dist
                end
            end
        end
    end
    if closestBicycle then
        return closestBicycle
    end
end

function FindFloorItem(player, item)
    local square = player:getSquare()
    local items = BicycleMenu.getItems(square)
    local closestBag = nil
    local closestBagDistance = 1000

    for i = 1, #items do
        local worldObj = items[i]
        if instanceof(worldObj, "IsoWorldInventoryObject") then
            local worldItem = worldObj:getItem()
            if string.find(worldItem:getType(), item) then
                local dist = BicycleMenu.getDistance2D(worldObj:getWorldPosX(), worldObj:getWorldPosY(), square:getX(), square:getY())
                if dist < closestBagDistance then
                    closestBag = worldObj
                    closestBagDistance = dist
                end
            end
        end
    end
    if closestBag then
        return closestBag
    end
end

function FindBasketFloor(player)
    local square = player:getSquare()
    local items = BicycleMenu.getItems(square)
    local closestBasket = nil
    local closestBasketDistance = 1000

    for i = 1, #items do
        local worldObj = items[i]
        if instanceof(worldObj, "IsoWorldInventoryObject") then
            local item = worldObj:getItem()
            if string.find(item:getType(), "^Basket") then
                local dist = BicycleMenu.getDistance2D(worldObj:getWorldPosX(), worldObj:getWorldPosY(), square:getX(), square:getY())
                if dist < closestBasketDistance then
                    closestBasket = worldObj
                    closestBasketDistance = dist
                end
            end
        end
    end
    if closestBasket then
        return closestBasket
    end
end

function FindEquippedItem(player, item)
    local playerInv = player:getInventory()
    local saddlebag = playerInv:getFirstTypeRecurse("Bicycle."..item)
    if saddlebag then
        return saddlebag
    end
end

function FindInventoryItem(player, item)
    local bags = player:getInventory():getAllCategory("Container")
    if bags then
        for i = 0, bags:size() - 1 do
            local bag = bags:get(i)
            if bag and bag:getInventory() then
                local foundItem = bag:getInventory():getFirstTypeRecurse("Bicycle."..item)
                if foundItem then
                    return foundItem, bag
                end
            end
        end
    end
    return nil
end

function FindEquippedBasket(player)
    local playerInv = player:getInventory()
    local basket = playerInv:getFirstTypeRecurse("Bicycle.Basket")
    if basket then
        return basket
    end
end

function FindContainerObject(player, worldItemType)
    local cell = getCell()
    local px,py,pz = player:getX(), player:getY(), player:getZ()
    for dx = -1,1 do
      for dy = -1,1 do
        local sq = cell:getGridSquare(px+dx, py+dy, pz)
        if sq then
          local list = sq:getLuaTileObjectList()
          for i = 0, list:size()-1 do
            local wobj = list:get(i)
            if instanceof(wobj, "IsoWorldInventoryObject")
            and wobj:getItem():getType() == worldItemType then
              return wobj
            end
          end
        end
      end
    end
    return nil
end