require "DebugUIs/AttachmentEditorUI"
require('ISUI/ISScrollingListBox')
require('Vehicles/ISUI/ISUI3DScene')

BicycleMenu ={};
BicycleMenu.typesTable = {"Bicycle"}

function BikeMsTimer(milliseconds, callback)
    local OnTick
    local startMs = getTimestampMs()
    local stopMs = startMs + milliseconds
    OnTick = function()
        if getTimestampMs() < stopMs then
            return
        end
        callback()  -- Execute the callback when time has elapsed.
        Events.OnTick.Remove(OnTick)
    end
    Events.OnTick.Add(OnTick)
end

BicycleMenu.onCompleteDrop = function(playerObj, weapon)
    playerObj:removeFromHands(weapon);
    BicycleAttachments.dropContainers()
    local pdata = getPlayerData(0)
    if pdata and pdata.playerInventory then
        pdata.playerInventory:refreshBackpacks()
        pdata.lootInventory:refreshBackpacks()
    end
    Events.OnPlayerUpdate.Remove(UpdateBicycleFlag)
    Events.OnPlayerUpdate.Remove(UpdateBicycleAudio)
    local emitter = playerObj:getEmitter()
    emitter:stopSoundByName('Bicycle_Riding')
    playerObj:setVariable("Bicycle_Riding", "false")
    playerObj:setVariable("BicycleActive", "false")
    playerObj:setCanShout(true);
    playerObj:setBannedAttacking(false)
    playerObj:setIgnoreAutoVault(false)
end

BicycleMenu.dropBicycle = function(worldobjects,items,player)
	local pzPlayer = getSpecificPlayer(player)
    local inv = pzPlayer:getInventory()
    pzPlayer:setBlockMovement(true)
    Events.OnPlayerUpdate.Remove(UpdateBicycleFlag)
    Events.OnPlayerUpdate.Remove(UpdateBicycleAudio)
    local action = ISInventoryTransferAction:new(pzPlayer, items[1], inv, ISInventoryPage.floorContainer[1], 0)
    action:setOnComplete(BicycleMenu.onCompleteDrop, pzPlayer, items[1])
    ISTimedActionQueue.add(action)
    BikeMsTimer(400, function()
        pzPlayer:setBlockMovement(false)
    end)
end

BicycleMenu.findNearestBicycleWithAttachments = function(square, pzPlayer)
    local items = BicycleMenu.getItems(square)
    local closestBicycle = nil
    local closestBicycleDistance = 1000
    local saddlebagItem = nil
    local basketItem = nil
    local crateItem = nil

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
            if item:getType() == "Saddlebag" then
                saddlebagPresent = true
                saddlebagItem = item
            end
            if item:getType() == "Basket" then
                basketPresent = true
                basketItem = item
            end
            if item:getType() == "Crate" then
                cratePresent = true
                crateItem = item
            end
        end
    end

    if closestBicycle then
        local bicycleParts = closestBicycle:getItem():getDetachableWeaponParts(pzPlayer)
        local saddlebagFound = false
        local basketFound = false
        local crateFound = false
        for i = 0, bicycleParts:size()-1 do
            local partName = bicycleParts:get(i):getType()
            if partName == "Bicycle_Saddlebag" then
                saddlebagFound = true
                saddlebagItem = FindFloorItem(closestBicycle, "Saddlebag")
            end
            if partName == "Bicycle_Basket" then
                basketFound = true
                basketItem = FindFloorItem(closestBicycle, "Basket")
            end
            if partName == "Bicycle_Crate" then
                crateFound = true
                crateItem = FindFloorItem(closestBicycle, "Crate")
            end
        end
        if not saddlebagFound and not basketFound and not crateFound then return closestBicycle, nil, nil, nil end
        return closestBicycle, saddlebagItem, basketItem, crateItem
    end

    return closestBicycle, saddlebagItem, basketItem, crateItem
end

function BicycleMenu.onCreateBicycle(item)
    if not item then return end
    item:attachWeaponPart(instanceItem("Bicycle.Bicycle_WheelFrontItem") , true)
    item:attachWeaponPart(instanceItem("Bicycle.Bicycle_WheelRearItem") , true)
    return item
end

AttachUI = nil
FrontWheel = nil
BackWheel = nil
Pedals = nil

function BicycleMenu.initRotationUI()
    AttachUI = AttachmentEditorUI:new(0, 0, 0, 0)
    AttachUI:initialise()
    AttachUI:instantiate()
    local modelScript = ScriptManager.instance:getModelScript("Base.Bicycle_Frame")
    AttachUI.editUI.attachments:setSelectedModel(modelScript)

    local list2 = AttachUI.editUI.attachments.list2
    list2:clear()
    for i=1, modelScript:getAttachmentCount() do
        local att = modelScript:getAttachment(i-1)
        list2:addItem(att:getId(), att)
    end

    list2:setSelectedRow(2)
    FrontWheel = list2:getSelectedItems()[1].item
    list2:setSelectedRow(4)
    BackWheel = list2:getSelectedItems()[1].item
    list2:setSelectedRow(6)
    Pedals = list2:getSelectedItems()[1].item
end

function BicycleMenu.rotateWheels()
    if not AttachUI then return end
    if not FrontWheel then return end
    if not BackWheel then return end

    local delta = Vector3f.new(-10, 0, 0)

    local rot = FrontWheel:getRotate():set(
        FrontWheel:getRotate():x(),
        FrontWheel:getRotate():y(),
        FrontWheel:getRotate():z()
    )
    local rot2 = BackWheel:getRotate():set(
        BackWheel:getRotate():x(),
        BackWheel:getRotate():y(),
        BackWheel:getRotate():z()
    )

    AttachUI.scene.javaObject:fromLua2("applyDeltaRotation", rot, delta)
    AttachUI.scene.javaObject:fromLua2("applyDeltaRotation", rot2, delta)
end

function BicycleMenu.rotatePedals()
    if not AttachUI then return end
    if not Pedals then return end

    local delta = Vector3f.new(-6.5, 0, 0)

    local rot = Pedals:getRotate():set(
        Pedals:getRotate():x(),
        Pedals:getRotate():y(),
        Pedals:getRotate():z()
    )

    AttachUI.scene.javaObject:fromLua2("applyDeltaRotation", rot, delta)
end



BicycleMenu.onKeyPressed = function(key)
    local bicycleOptions = PZAPI.ModOptions:getOptions("BicycleMod")
    local Equip_KEY = bicycleOptions:getOption("BicycleEquipButton"):getValue()
    local pzPlayer = getSpecificPlayer(0)
    -- if key == Keyboard.KEY_G then
    --     -- local vehicle = pzPlayer:getUseableVehicle()
    --     -- if vehicle then
    --     --     local part = vehicle:getUseablePart(pzPlayer)
    --     --     if part then
    --     --         if part:getDoor() and part:getInventoryItem() then
    --     --             local isHood = part:getId() == "EngineDoor"
    --     --             local isTrunk = part:getId() == "TrunkDoor" or part:getId() == "DoorRear"
    --     --             print("Is trunk: ", isTrunk)
    --     --         end
    --     --     end
    --     -- end
    -- end
    if getCore():isKey("Shout", key) and pzPlayer:getVariableBoolean("BicycleActive") then
        local emitter = pzPlayer:getEmitter()
        local soundVolume = PZAPI.ModOptions:getOptions("BicycleMod"):getOption("BicycleSoundVolume"):getValue()
        local sound = emitter:playSound('Bicycle_Bell')
        emitter:setVolume(sound, soundVolume)
        addSound(nil, pzPlayer:getX(), pzPlayer:getY(), pzPlayer:getZ(), 20, 20)
    end
    if key ~= Equip_KEY then return end
    if not pzPlayer then return end
    if pzPlayer:isDoingActionThatCanBeCancelled() then return end
    local midSq = pzPlayer:getSquare()
    local squares = {}
    table.insert(squares,midSq)
    table.insert(squares,midSq:getN())
    table.insert(squares,midSq:getS())
    table.insert(squares,midSq:getE())
    table.insert(squares,midSq:getW())

    for i,sq in ipairs(squares) do
        local door = sq:getIsoDoor()
        if door then
            if door:getSquare() == midSq or door:isAdjacentToSquare(midSq) then
                return
            end
        end
    end
    local currentItem = pzPlayer:getPrimaryHandItem()
    if currentItem and currentItem:getType() == "Bicycle" then
        BicycleMenu.dropBicycle(nil, {currentItem}, 0)
    else
        local sq = pzPlayer:getSquare()
        local closestBicycle, saddlebagItem, basketItem, crateItem = BicycleMenu.findNearestBicycleWithAttachments(sq, pzPlayer)
        if closestBicycle then
            local bicycleParts = closestBicycle:getItem():getDetachableWeaponParts(pzPlayer)
            local frontWheelFound = false
            local rearWheelFound = false
            for i = 0, bicycleParts:size()-1 do
                local partName = bicycleParts:get(i):getType()
                if partName == "Bicycle_WheelFrontItem" then
                    frontWheelFound = true
                elseif partName == "Bicycle_WheelRearItem" then
                    rearWheelFound = true
                end
            end
            if frontWheelFound and rearWheelFound then
                BicycleMenu.equipBicycle({closestBicycle}, 0, closestBicycle, saddlebagItem, basketItem, crateItem)
                return
            elseif frontWheelFound or rearWheelFound then
                pzPlayer:Say("This bicycle is missing a wheel!")
                pzPlayer:setBlockMovement(false)
                return
            else
                pzPlayer:Say("This bicycle is missing both wheels!")
                pzPlayer:setBlockMovement(false)
                return
            end
        end
    end
end

BicycleMenu.transferToTrunk = function(worldObjects, playerObj, item, src, dest, time)
    ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, item, src, dest, time))
end

BicycleMenu.addWorldContext = function(player, context, worldobjects, test)
    local pzPlayer = getSpecificPlayer(player)
    local current_weapon = pzPlayer:getPrimaryHandItem()
    if current_weapon ~= nil and current_weapon:getType() == "Bicycle" then
        context:addOption("Hop off bicycle", worldobjects, BicycleMenu.dropBicycle, {current_weapon}, player)
        local vehicle = pzPlayer:getUseableVehicle()
        local moddedTrunk = nil
        if vehicle then
            for i = 0, vehicle:getPartCount() - 1 do
                local part = vehicle:getPartByIndex(i)
                local id   = part:getId()

                if id ~= "TrunkDoor" and id:find("Trunk") then
                    moddedTrunk = part
                    break
                end
            end
            local part = vehicle:getUseablePart(pzPlayer)
            local playerInv = pzPlayer:getInventory()
            if part then
                if part:getDoor() and part:getInventoryItem() then
                    local isTrunk = part:getId() == "TrunkDoor" or part:getId() == "DoorRear"
                    local trunk = moddedTrunk
                    if not trunk then
                        trunk = vehicle:getPartById("TruckBed")
                    end
                    if not trunk then
                        trunk = vehicle:getPartById("TruckBedOpen")
                    end
                    if not trunk then
                        trunk = vehicle:getPartById("TrailerTrunk")
                    end
                    if isTrunk and vehicle:canAccessContainer(trunk:getIndex(), pzPlayer) then
                        context:addOption("Put bicycle in trunk", worldobjects, BicycleMenu.transferToTrunk, pzPlayer, current_weapon, playerInv, trunk:getItemContainer(), 80)
                    end
                    if isTrunk and vehicle:isTrunkLocked() and vehicle:canUnlockDoor(part, pzPlayer) then
                        part:getDoor():setLocked(false)
                        part:getDoor():setOpen(true)
                        context:addOption("Unlock trunk and put bicycle in", worldobjects, BicycleMenu.transferToTrunk, pzPlayer, current_weapon, playerInv, trunk:getItemContainer(), 80)
                    end
                    if isTrunk and not vehicle:isTrunkLocked() and not part:getDoor():isOpen() then
                        part:getDoor():setOpen(true)
                        context:addOption("Open trunk and put bicycle in", worldobjects, BicycleMenu.transferToTrunk, pzPlayer, current_weapon, playerInv, trunk:getItemContainer(), 80)
                    end
                end
            end
        end
        return
    end

    local origSq = worldobjects[1]:getSquare()
    if not instanceof(origSq, "IsoGridSquare") then
        return
    end

    local closestBicycle, saddlebagItem, basketItem, crateItem = BicycleMenu.findNearestBicycleWithAttachments(origSq, pzPlayer)

    if closestBicycle then
        local bicycleParts = closestBicycle:getItem():getDetachableWeaponParts(pzPlayer)
        local frontWheelFound = false
        local rearWheelFound = false

        for i = 0, bicycleParts:size()-1 do
            local partName = bicycleParts:get(i):getType()
            if partName == "Bicycle_WheelFrontItem" then
                frontWheelFound = true
            elseif partName == "Bicycle_WheelRearItem" then
                rearWheelFound = true
            end
        end

        if frontWheelFound and rearWheelFound then
            context:addOption("Hop on Bicycle", worldobjects, BicycleMenu.equipBicycle, player, closestBicycle, saddlebagItem, basketItem, crateItem)
        elseif frontWheelFound or rearWheelFound then
            pzPlayer:Say("This bicycle is missing a wheel!")
            pzPlayer:setBlockMovement(false)
        else
            pzPlayer:Say("This bicycle is missing both wheels!")
            pzPlayer:setBlockMovement(false)
        end
    end
end

BicycleMenu.equipBicycle = function(worldobjects, player, item, saddlebag, basket, crate)
    local pzPlayer = getSpecificPlayer(0)
    local sqP = pzPlayer:getSquare()
    local sqC = item:getSquare()
    local sqCx = sqC:getX()
    local sqCy = sqC:getY()

    pzPlayer:faceLocation(sqCx, sqCy)

    local d = BicycleMenu.getDistance2D(sqP:getX(), sqP:getY(), sqCx, sqCy)
    if d > 1.5 then
        ISTimedActionQueue.add(ISWalkToTimedAction:new(pzPlayer, item:getSquare()))
        pzPlayer:setBlockMovement(true)
        BikeMsTimer(400, function()
            pzPlayer:setBlockMovement(false)
        end)
        ISTimedActionQueue.add(BicycleHopOnAction:new(item, pzPlayer, saddlebag, basket, crate))
    else
        pzPlayer:setBlockMovement(true)
        BikeMsTimer(400, function()
            pzPlayer:setBlockMovement(false)
        end)
        ISTimedActionQueue.add(BicycleHopOnAction:new(item, pzPlayer, saddlebag, basket, crate))
    end
end

BicycleMenu.getItems = function(square)
	local items ={}
	local squares ={}
	if instanceof(square, "IsoGridSquare") == false then return items end
	table.insert(squares,square)
    if square.getN and square:getN() then
        table.insert(squares,square:getN())
    end
    if square.getN and square:getN() and square:getN().getE then
        table.insert(squares,square:getN():getE())
    end
    if square.getN and square:getN() and square:getN().getW then
        table.insert(squares,square:getN():getW())
    end
    if square.getS and square:getS() then
        table.insert(squares,square:getS())
    end
    if square.getS and square:getS() and square:getS().getE then
        table.insert(squares,square:getS():getE())
    end
    if square.getS and square:getS() and square:getS().getW then
        table.insert(squares,square:getS():getW())
    end
    if square.getE and square:getE() then
        table.insert(squares,square:getE())
    end
    if square.getW and square:getW() then
        table.insert(squares,square:getW())
    end
	for si,s in ipairs(squares) do
		for ii,i in ipairs(s:getLuaTileObjectList()) do
			table.insert(items,i)
		end
	end
	return items
end

BicycleMenu.initBicycle = function()
	local player = getSpecificPlayer(0)
	local options = PZAPI.ModOptions:getOptions("BicycleMod")
    local speedMultSlow = options:getOption("SpeedMultSlow"):getValue()
    local speedMultFast = options:getOption("SpeedMultFast"):getValue()
    local primaryItem = player:getPrimaryHandItem()
    if not primaryItem then
        player:setVariable("BicycleActive", "false")
        player:setIgnoreAutoVault(false)
        player:setCanShout(true);
        player:setBannedAttacking(false)
        return
    end
    if primaryItem and primaryItem:getType() == "Bicycle" then
		player:setVariable("BicycleActive", "true")
        player:setCanShout(false);
        player:setBannedAttacking(true)
		player:setIgnoreAutoVault(true)
		Events.OnPlayerUpdate.Add(UpdateBicycleFlag)
		Events.OnPlayerUpdate.Add(UpdateBicycleAudio)
	end

    player:setVariable("BicycleWalkSpeed", speedMultSlow)
    player:setVariable("BicycleRunSpeed", speedMultFast)
	player:setVariable("Bicycle_Riding", false)
	player:setVariable("Bicycle_Stopping", false)
	player:setVariable("droppingBicycle", false)
	player:setVariable("BicycleRollingTimestamp", "0")
end

BicycleMenu.getDistance2D = function(_x1, _y1, _x2, _y2)
	return math.sqrt(math.abs(_x2 - _x1)^2 + math.abs(_y2 - _y1)^2);
end

function SpawnBicycle()
    local player = getSpecificPlayer(0)
    local playerInv = player:getInventory()
    playerInv:AddItem("Bicycle.Bicycle")
end

function SpawnBicycleSaddlebag()
    local player = getSpecificPlayer(0)
    local playerInv = player:getInventory()
    playerInv:AddItem("Bicycle.Bicycle_Saddlebag")
end

function SpawnBicycleBasket()
    local player = getSpecificPlayer(0)
    local playerInv = player:getInventory()
    playerInv:AddItem("Bicycle.Bicycle_Basket")
end

function SpawnBicycleCrate()
    local player = getSpecificPlayer(0)
    local playerInv = player:getInventory()
    playerInv:AddItem("Bicycle.Bicycle_Crate")
end

function FixAutoVault()
    local player = getSpecificPlayer(0)
    player:setIgnoreAutoVault(false)
end

Events.OnKeyPressed.Add(BicycleMenu.onKeyPressed)
Events.OnGameStart.Add(BicycleMenu.initRotationUI)
Events.OnGameStart.Add(BicycleMenu.initBicycle)
Events.OnPreFillWorldObjectContextMenu.Add(BicycleMenu.addWorldContext)