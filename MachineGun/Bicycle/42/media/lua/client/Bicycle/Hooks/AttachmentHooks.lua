ContainerMap = {
    Saddlebag = "Saddlebag",
    Basket   = "Basket",
    Crate    = "Crate",
}

local options = PZAPI.ModOptions:getOptions("BicycleMod")

local originalUpgrade = ISInventoryPaneContextMenu.onUpgradeWeapon

function ISInventoryPaneContextMenu.onUpgradeWeapon(weapon, part, player)
    local primaryItem = player:getPrimaryHandItem()
    local pzPlayer = player
    if not pzPlayer then
        pzPlayer = getSpecificPlayer(0)
    end
    if primaryItem and primaryItem:getType() == "Bicycle" then pzPlayer:Say("I should hop off first") return end
    if weapon:getType() == "Bicycle" then
        pzPlayer:setVariable("BicycleUpgrading", true)
        ISTimedActionQueue.add(ISUpgradeWeapon:new(pzPlayer, weapon, part));
        BikeMsTimer(1300, function()
            if part:getPartType() == ContainerMap[part:getPartType()] then
                local bike = FindBicycle(pzPlayer)
                if not bike then
                    pzPlayer:Say("I should stand closer to the bike")
                    return
                end
                local bikeSq = bike:getSquare()
                if not bikeSq then
                    pzPlayer:Say("I should stand closer to the bike")
                    return
                end
                bikeSq:AddWorldInventoryItem("Bicycle."..ContainerMap[part:getPartType()], 0.0, 0.0, 0.0)
                local pdata = getPlayerData(0)
                if pdata and pdata.playerInventory then
                    pdata.playerInventory:refreshBackpacks()
                    pdata.lootInventory:refreshBackpacks()
                end
            end
            local xRot = weapon:getWorldXRotation();
            weapon:setWorldXRotation(xRot+1);
            pzPlayer:setVariable("BicycleUpgrading", false)
        end)
        return;
    end
    return originalUpgrade(weapon, part, pzPlayer)
end

local originalDowngrade = ISInventoryPaneContextMenu.onRemoveUpgradeWeapon

function ISInventoryPaneContextMenu.onRemoveUpgradeWeapon(weapon, part, playerObj)
    local primaryItem = playerObj:getPrimaryHandItem()
    if primaryItem and primaryItem:getType() == "Bicycle" then playerObj:Say("I should hop off first") return end
    if weapon:getType() == "Bicycle" then
        local bag = nil
        local bagSq = nil
        if part:getPartType() == ContainerMap[part:getPartType()] then
            bag = FindFloorItem(playerObj, ContainerMap[part:getPartType()])
            if bag and not bag:getItem():isEmpty() then
                playerObj:Say("I should empty the bag first")
                return
            end
        end
        playerObj:setVariable("BicycleUpgrading", true)
        if part:getPartType() == ContainerMap[part:getPartType()] and not bag then
            bag = FindFloorItem(weapon:getWorldItem(), ContainerMap[part:getPartType()])
        end
        ISTimedActionQueue.add(ISRemoveWeaponUpgrade:new(playerObj, weapon, part:getPartType()));
        BikeMsTimer(1300, function()
            if part:getPartType() == ContainerMap[part:getPartType()] and bag then
                if bagSq then
                    bagSq:transmitRemoveItemFromSquare(bag)
                end
                bag:removeFromWorld()
                bag:removeFromSquare()
                local pdata = getPlayerData(0)
                if pdata and pdata.playerInventory then
                    pdata.playerInventory:refreshBackpacks()
                    pdata.lootInventory:refreshBackpacks()
                end
            end
            local xRot = weapon:getWorldXRotation();
            weapon:setWorldXRotation(xRot+1);
            playerObj:setVariable("BicycleUpgrading", false)
        end)
        return;
    end
    return originalDowngrade(weapon, part, playerObj)
end

local originalDowngradeValid = ISRemoveWeaponUpgrade.isValid

function ISRemoveWeaponUpgrade:isValid()
    if self.weapon:getType() == "Bicycle" then
        return self.weapon:getWeaponPart(self.partType) ~= nil
    end;
    return originalDowngradeValid(self)
end

local originalNewAttachmentEditor = AttachmentEditorUI.new

function AttachmentEditorUI:new(x, y, width, height)
    local editorFix = options:getOption("BicycleEditorFix"):getValue()
    if editorFix then
        return originalNewAttachmentEditor(self, x, y, width, height)
    end
    local o = ISPanel.new(self, x, y, width, height)
	o:setAnchorRight(true)
	o:setAnchorBottom(true)
	o:noBackground()
	o:setWantKeyEvents(true)
	return o
end

local originalAttachmentOnExit = AttachmentEditorUI.onExit

function AttachmentEditorUI:onExit(button, x, y)
    local editorFix = options:getOption("BicycleEditorFix"):getValue()
    if editorFix then
        return originalAttachmentOnExit(self, button, x, y)
    end
    print("HEY MODDER! Message from Bicycle mod, you need to enable the mod option to make the attachment editor work properly. Sorry about that!")
    getAttachmentEditorState():fromLua0("exit")
end

local originalAttachmentOnSave = AttachmentEditorUI.onSave

function AttachmentEditorUI:onSave(button, x, y)
    local editorFix = options:getOption("BicycleEditorFix"):getValue()
    if editorFix then
        return originalAttachmentOnSave(self, button, x, y)
    end
	local item = self.editUI.attachments.list:getSelectedItems()[1]
	if item then
		-- Empty to override attachment editor state check
	end
end

local EditAttachment = AttachmentEditorUI_EditAttachment

function EditAttachment:setPlayerAnimationCombo()
    local editorFix = options:getOption("BicycleEditorFix"):getValue()
    if editorFix then
        return originalAttachmentOnExit(self)
    end
	-- Empty to override attachment editor state check
end